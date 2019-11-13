require "geckoboard"

class RecordSubmittedClaimJob < ApplicationJob
  def perform(claim)
    RecordClaimEvent.new(claim, :submitted, claim.submitted_at).perform
  end
end
