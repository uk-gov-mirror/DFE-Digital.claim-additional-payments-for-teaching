# frozen_string_literal: true

require "rails_helper"

RSpec.describe PolicyConfiguration do
  describe "#policy" do
    it "returns the policy class" do
      expect(policy_configurations(:student_loans).policy).to eq(StudentLoans)
    end
  end
end
