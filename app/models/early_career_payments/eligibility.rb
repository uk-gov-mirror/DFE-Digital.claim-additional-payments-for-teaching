module EarlyCareerPayments
  class Eligibility < ApplicationRecord
    EDITABLE_ATTRIBUTES = [
      :nqt_in_academic_year_after_itt,
      :pgitt_or_ugitt_course
    ].freeze
    AMENDABLE_ATTRIBUTES = [].freeze

    self.table_name = "early_career_payments_eligibilities"

    enum pgitt_or_ugitt_course: {
      postgraduate: 0,
      undergraduate: 1
    }, _suffix: :itt_course

    has_one :claim, as: :eligibility, inverse_of: :eligibility

    validates :nqt_in_academic_year_after_itt, on: [:"nqt-in-academic-year-after-itt", :submit], inclusion: {in: [true, false], message: "Select yes if you did your NQT in the academic year after your ITT"}
    validates :pgitt_or_ugitt_course, on: [:"postgraduate-itt-or-undergraduate-itt-course", :submit], presence: {message: "Select postgraduate if you did a Postgraduate ITT course"}

    def policy
      EarlyCareerPayments
    end

    def ineligible?
      ineligible_nqt_in_academic_year_after_itt?
    end

    def award_amount
      BigDecimal("2000.00")
    end

    private

    def ineligible_nqt_in_academic_year_after_itt?
      nqt_in_academic_year_after_itt == false
    end
  end
end
