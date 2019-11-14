require "rails_helper"

RSpec.describe UpdateClaimCheckStats, type: :model do
  let(:claim) { build(:claim, :submitted) }
  let(:event) { :submitted }

  let(:client) { double("Geckoboard::Client") }
  let(:dataset) { double("Geckoboard::Dataset") }

  subject { described_class.new }

  let!(:submitted_claims) { create_list(:claim, 5, :submitted) }
  let!(:submitted_claims_past_deadline) { create_list(:claim, 5, :submitted_and_past_deadline) }
  let!(:unsubmitted_claims) { create_list(:claim, 2, :submittable) }
  let!(:approved_claims) { create_list(:claim, 5, :approved) }

  before do
    allow(subject).to receive(:client).and_return(client)
    allow(client).to receive_message_chain(:datasets, :find_or_create).with(
      "claims.metrics.#{ENV["ENVIRONMENT_NAME"]}",
      fields: UpdateClaimCheckStats::DATASET_FIELDS
    ).and_return(dataset)
  end

  it "sends the correct data to Geckoboard" do
    expect(dataset).to receive(:put).with([
      {
        metric: "AwaitingChecking",
        count: 10,
      },
      {
        metric: "PassedCheckDeadline",
        count: 5,
      },
    ])

    subject.perform
  end

  it "has the right fields" do
    expect(described_class::DATASET_FIELDS.count).to eq(2)

    expect(described_class::DATASET_FIELDS[0]).to be_a(Geckoboard::StringField)
    expect(described_class::DATASET_FIELDS[0].id).to eq(:metric)
    expect(described_class::DATASET_FIELDS[0].name).to eq("Metric")

    expect(described_class::DATASET_FIELDS[1]).to be_a(Geckoboard::NumberField)
    expect(described_class::DATASET_FIELDS[1].id).to eq(:count)
    expect(described_class::DATASET_FIELDS[1].name).to eq("Count")
  end
end
