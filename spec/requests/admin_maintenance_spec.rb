require "rails_helper"

RSpec.describe "Service maintenance" do
  let(:policy_configuration) { policy_configurations(:student_loans) }

  context "when signed in as a service operator" do
    before do
      sign_in_to_admin_with_role(AdminSession::SERVICE_OPERATOR_DFE_SIGN_IN_ROLE_CODE)
    end

    describe "admin_policy_configurations#update" do
      it "sets the configuration's availability message and status" do
        patch admin_policy_configuration_path(policy_configuration, policy_configuration: {maintenance_mode: true, maintenance_mode_availability_message: "Test message"})

        expect(response).to redirect_to(admin_policy_configurations_path)

        policy_configuration.reload
        expect(policy_configuration.maintenance_mode).to be true
        expect(policy_configuration.maintenance_mode_availability_message).to eq("Test message")
      end

      context "with an empty availability message" do
        it "sets the configuration's availability_message to nil" do
          patch admin_policy_configuration_path(policy_configuration, policy_configuration: {maintenance_mode_availability_message: ""})

          expect(response).to redirect_to(admin_policy_configurations_path)

          policy_configuration.reload
          expect(policy_configuration.maintenance_mode_availability_message).to be_nil
        end
      end
    end
  end

  context "when signed in as a support user" do
    before do
      sign_in_to_admin_with_role(AdminSession::SUPPORT_AGENT_DFE_SIGN_IN_ROLE_CODE)
    end

    describe "admin_policy_configurations#update" do
      it "returns a unauthorized response" do
        patch admin_policy_configuration_path(policy_configuration, policy_configuration: {maintenance_mode: true, maintenance_mode_availability_message: "Test message"})

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
