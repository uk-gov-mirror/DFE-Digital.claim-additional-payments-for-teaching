require "rails_helper"
require "geckoboard"

RSpec.describe RecordSubmittedClaimJob do
  let(:claim) { build(:claim, :submitted) }
  let(:client) { double("Geckoboard::Client") }
  let(:dataset) { double("Geckoboard::Dataset") }

  subject { described_class.new }

  before do
    allow(subject).to receive(:client).and_return(client)
    allow(client).to receive_message_chain(:datasets, :find_or_create).with(
      subject.dataset_name,
      fields: subject.fields
    ).and_return(dataset)
  end

  it "sends the correct data to Geckoboard" do
    expect(dataset).to receive(:post).with([
      {
        reference: claim.reference,
        policy: claim.policy.to_s,
        submitted_at: claim.submitted_at,
      },
    ])

    subject.perform(claim)
  end

  it "has the right dataset name" do
    ClimateControl.modify ENVIRONMENT_NAME: "test" do
      expect(subject.dataset_name).to eq("claims.submitted.test")
    end
  end

  it "has the right fields" do
    expect(subject.fields.count).to eq(3)

    expect(subject.fields[0]).to be_a(Geckoboard::StringField)
    expect(subject.fields[0].id).to eq(:reference)
    expect(subject.fields[0].name).to eq("Reference")

    expect(subject.fields[1]).to be_a(Geckoboard::StringField)
    expect(subject.fields[1].id).to eq(:policy)
    expect(subject.fields[1].name).to eq("Policy")

    expect(subject.fields[2]).to be_a(Geckoboard::DateTimeField)
    expect(subject.fields[2].id).to eq(:submitted_at)
    expect(subject.fields[2].name).to eq("Date Submitted")
  end
end
