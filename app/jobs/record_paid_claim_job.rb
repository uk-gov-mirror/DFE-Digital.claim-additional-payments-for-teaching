require "geckoboard"

class RecordPaidClaimJob < ApplicationJob
  def perform(claim)
    RecordClaimEvent.new(claim, :paid, claim.payment.updated_at).perform
  end
end
