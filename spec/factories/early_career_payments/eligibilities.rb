FactoryBot.define do
  factory :early_career_payments_eligibility, class: "EarlyCareerPayments::Eligibility" do
    trait :eligible do
      has_entire_term_contract { true }
      nqt_in_academic_year_after_itt { true }
    end
  end
end
