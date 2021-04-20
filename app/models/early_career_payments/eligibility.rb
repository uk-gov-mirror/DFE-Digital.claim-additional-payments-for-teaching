module EarlyCareerPayments
  class Eligibility < ApplicationRecord
    EDITABLE_ATTRIBUTES = [
      :has_entire_term_contract,
      :nqt_in_academic_year_after_itt
    ].freeze
    AMENDABLE_ATTRIBUTES = [].freeze

    self.table_name = "early_career_payments_eligibilities"

    has_one :claim, as: :eligibility, inverse_of: :eligibility

    validates :has_entire_term_contract, on: [:"entire-term-contract", :submit], inclusion: {in: [true, false], message: "Select yes if you have a contract to teach at the same school for one term or longer"}#, if: :employed_as_supply_teacher?
    validates :nqt_in_academic_year_after_itt, on: [:"nqt-in-academic-year-after-itt", :submit], inclusion: {in: [true, false], message: "Select yes if you did your NQT in the academic year after your ITT"}

    def policy
      EarlyCareerPayments
    end

    def ineligible?
      ineligible_nqt_in_academic_year_after_itt? ||
        no_entire_term_contract?
    end

    def award_amount
      BigDecimal("2000.00")
    end

    private

    def ineligible_nqt_in_academic_year_after_itt?
      nqt_in_academic_year_after_itt == false
    end

    def no_entire_term_contract?
      has_entire_term_contract == false
    end
  end
end
