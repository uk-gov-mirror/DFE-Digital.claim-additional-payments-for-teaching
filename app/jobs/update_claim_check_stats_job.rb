class UpdateClaimCheckStatsJob < ApplicationJob
  def perform
    UpdateClaimCheckStats.new.perform
  end
end
