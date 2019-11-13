require "rails_helper"

RSpec.describe "Admin Payment Confirmation Report upload" do
  let(:payroll_run) { create(:payroll_run) }

  context "when signed in as a service operator" do
    let(:admin_session_id) { "some_user_id" }
    before do
      sign_in_to_admin_with_role(AdminSession::SERVICE_OPERATOR_DFE_SIGN_IN_ROLE_CODE, admin_session_id)
    end

    describe "payment_confirmation_report_uploads#new" do
      it "returns an OK response" do
        get new_admin_payroll_run_payment_confirmation_report_upload_path(payroll_run)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "payment_confirmation_report_uploads#create" do
      let(:file) { Rack::Test::UploadedFile.new(StringIO.new(csv), "text/csv", original_filename: "payments.csv") }

      context "the claims in the CSV match the claims of the payroll run" do
        let(:updated_at) { Time.zone.parse("2019-01-01") }
        let(:payroll_run) { create(:payroll_run, claims_count: 2) }
        let(:csv) do
          <<~CSV
            Payroll Reference,Gross Value,Claim ID,NI,Employers NI,Student Loans,Tax,Net Pay
            DFE00001,487.48,#{payroll_run.claims[0].reference},33.9,38.98,0,89.6,325
            DFE00002,904.15,#{payroll_run.claims[1].reference},77.84,89.51,40,162.8,534
          CSV
        end

        before do
          @claim_events = []
          payroll_run.claims.each_with_index do |claim, i|
            @claim_events[i] = double("RecordClaimEvent", perform: nil)
            expect(RecordClaimEvent).to receive(:new).with(claim, :paid, an_instance_of(ActiveSupport::TimeWithZone)) { @claim_events[i] }
          end

          perform_enqueued_jobs do
            post admin_payroll_run_payment_confirmation_report_uploads_path(payroll_run), params: {file: file}
          end
        end

        it "records the values from the CSV against the claims' payments and sends emails" do
          expect(response).to redirect_to(admin_payroll_runs_path)

          expect(payroll_run.claims[0].reload.payment.payroll_reference).to eq("DFE00001")
          expect(payroll_run.claims[1].reload.payment.payroll_reference).to eq("DFE00002")

          expect(payroll_run.reload.confirmation_report_uploaded_by).to eq(admin_session_id)

          expect(ActionMailer::Base.deliveries.count).to eq(2)
        end

        it "sends the events to Geckoboard" do
          payroll_run.claims.each_with_index do |claim, i|
            expect(@claim_events[i]).to have_received(:perform)
          end
        end
      end

      context "the CSV has invalid data" do
        let(:payroll_run) { create(:payroll_run, claims_count: 2) }
        let(:csv) do
          <<~CSV
            Payroll Reference,Gross Value,Claim ID,NI,Employers NI,Student Loans,Tax,Net Pay
            DFE00001,487.48,#{payroll_run.claims[0].reference},33.9,38.98,0,89.6,325
            DFE00002,904.15,#{payroll_run.claims[1].reference},77.84,89.51,40,162.8,
          CSV
        end

        it "displays errors and does not send emails" do
          perform_enqueued_jobs do
            post admin_payroll_run_payment_confirmation_report_uploads_path(payroll_run), params: {file: file}
          end

          expect(response).to have_http_status(:ok)
          expect(response.body).to include("The claim at line 3 has invalid data")
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      context "the CSV is not present" do
        it "displays an error message" do
          post admin_payroll_run_payment_confirmation_report_uploads_path(payroll_run)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include("You must provide a file")
        end
      end
    end
  end

  context "when signed in as a support user" do
    before do
      sign_in_to_admin_with_role(AdminSession::SUPPORT_AGENT_DFE_SIGN_IN_ROLE_CODE)
    end

    describe "payment_confirmation_report_uploads#new" do
      it "returns an unauthorized response" do
        get new_admin_payroll_run_payment_confirmation_report_upload_path(payroll_run)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
