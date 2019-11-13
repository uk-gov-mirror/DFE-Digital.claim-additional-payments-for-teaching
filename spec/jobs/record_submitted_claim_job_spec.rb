require "rails_helper"
require "geckoboard"

RSpec.describe RecordSubmittedClaimJob do
  let(:claim) { build(:claim, :submitted) }
  let(:client) { double("Geckoboard::Client") }
  let(:dataset) { double("Geckoboard::Dataset") }

  subject { described_class.new }

  it "records a submitted event" do
    record_claim_event = double("RecordClaimEvent")
    expect(RecordClaimEvent).to receive(:new).with(claim, :submitted, claim.submitted_at) { record_claim_event }
    expect(record_claim_event).to receive(:perform)

    subject.perform(claim)
  end
end
