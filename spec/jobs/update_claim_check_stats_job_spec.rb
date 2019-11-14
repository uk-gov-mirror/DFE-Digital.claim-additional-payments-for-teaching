require "rails_helper"

RSpec.describe UpdateClaimCheckStatsJob do
  subject { described_class.new }

  it "updates the stats" do
    update_claim_check_stats = double("UpdateClaimCheckStats")
    expect(UpdateClaimCheckStats).to receive(:new) { update_claim_check_stats }
    expect(update_claim_check_stats).to receive(:perform)

    subject.perform
  end
end
