require "rails_helper"
require "geckoboard"

RSpec.describe RecordPaidClaimJob do
  let(:claim) { create(:payment, :with_figures).claim }
  let(:client) { double("Geckoboard::Client") }
  let(:dataset) { double("Geckoboard::Dataset") }

  subject { described_class.new }

  it "records a paid event" do
    record_claim_event = double("RecordClaimEvent")
    expect(RecordClaimEvent).to receive(:new).with(claim, :paid, claim.payment.updated_at) { record_claim_event }
    expect(record_claim_event).to receive(:perform)

    subject.perform(claim)
  end
end
