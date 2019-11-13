require "rails_helper"

RSpec.describe RecordClaimEvent, type: :model do
  let(:claim) { build(:claim, :submitted) }
  let(:event) { :submitted }
  let(:datetime) { DateTime.now }

  let(:client) { double("Geckoboard::Client") }
  let(:dataset) { double("Geckoboard::Dataset") }

  subject { described_class.new(claim, :submitted, datetime) }

  before do
    allow(subject).to receive(:client).and_return(client)
    allow(client).to receive_message_chain(:datasets, :find_or_create).with(
      "claims.#{event}.#{ENV["ENVIRONMENT_NAME"]}",
      fields: RecordClaimEvent::DATASET_FIELDS
    ).and_return(dataset)
  end

  it "sends the correct data to Geckoboard" do
    expect(dataset).to receive(:post).with([
      {
        reference: claim.reference,
        policy: claim.policy.to_s,
        performed_at: datetime,
      },
    ])

    subject.perform
  end

  it "has the right fields" do
    expect(described_class::DATASET_FIELDS.count).to eq(3)

    expect(described_class::DATASET_FIELDS[0]).to be_a(Geckoboard::StringField)
    expect(described_class::DATASET_FIELDS[0].id).to eq(:reference)
    expect(described_class::DATASET_FIELDS[0].name).to eq("Reference")

    expect(described_class::DATASET_FIELDS[1]).to be_a(Geckoboard::StringField)
    expect(described_class::DATASET_FIELDS[1].id).to eq(:policy)
    expect(described_class::DATASET_FIELDS[1].name).to eq("Policy")

    expect(described_class::DATASET_FIELDS[2]).to be_a(Geckoboard::DateTimeField)
    expect(described_class::DATASET_FIELDS[2].id).to eq(:performed_at)
    expect(described_class::DATASET_FIELDS[2].name).to eq("Performed at")
  end
end
