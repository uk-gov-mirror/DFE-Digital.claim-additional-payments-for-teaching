require "rails_helper"

RSpec.feature "Applicant worked at multiple schools" do
  let(:eligibility) { claim.eligibility }

  let!(:claim) { start_claim }

  context "first claim school is ineligible" do
    let!(:ineligible_school) { schools(:bradford_grammar_school) }

    scenario "subsequent school is eligible" do
      choose_school schools(:hampstead_school)

      expect(claim.eligibility.reload.claim_school).to eq schools(:hampstead_school)
      expect(page).to have_text("This school is not eligible")
      expect(page).to have_text("Hampstead School is not an eligible school.")

      click_on "Enter another school"

      expect(page).to_not have_css("input[value=\"Hampstead School\"]")
      expect(page).to have_text(I18n.t("student_loans.questions.additional_school"))

      choose_school schools(:penistone_grammar_school)
      expect(claim.eligibility.reload.claim_school).to eq schools(:penistone_grammar_school)

      expect(page).to have_text(I18n.t("student_loans.questions.subjects_taught", school: schools(:penistone_grammar_school).name))
    end

    scenario "subsequent school is ineligible too" do
      choose_school schools(:hampstead_school)
      click_on "Enter another school"

      choose_school ineligible_school
      expect(page).to have_text("This school is not eligible")
      expect(page).to have_text("#{ineligible_school.name} is not an eligible school.")

      click_on "I've tried all of my schools"

      expect(page).to have_text("You're not eligible for this payment")
    end
  end

  context "first school is eligible, but didn't teach eligible subjects" do
    let!(:eligible_school) { create(:school, :student_loan_eligible) }

    scenario "taught eligible subjects at a different eligible school" do
      choose_school schools(:penistone_grammar_school)

      choose I18n.t("student_loans.questions.eligible_subjects.none_taught")
      click_on "Continue"

      expect(page).to have_text("You did not select an eligible subject")
      expect(page).to have_text("You did not teach an eligible subject at Penistone Grammar School.")

      click_on "Enter another school"

      expect(page).to_not have_css("input[value=\"Penistone Grammar School\"]")
      expect(page).to have_text(I18n.t("student_loans.questions.additional_school"))

      choose_school eligible_school

      check I18n.t("student_loans.questions.eligible_subjects.biology_taught")
      check I18n.t("student_loans.questions.eligible_subjects.physics_taught")
      click_on "Continue"

      expect(claim.eligibility.reload.taught_eligible_subjects).to eq(true)
      expect(claim.eligibility.biology_taught).to eq(true)
      expect(claim.eligibility.physics_taught).to eq(true)
    end

    scenario "did not teach eligible subjects at a different eligible school" do
      choose_school schools(:penistone_grammar_school)

      choose I18n.t("student_loans.questions.eligible_subjects.none_taught")
      click_on "Continue"

      click_on "Enter another school"

      choose_school eligible_school

      choose I18n.t("student_loans.questions.eligible_subjects.none_taught")
      click_on "Continue"

      expect(page).to have_text("You did not select an eligible subject")
      expect(page).to have_text("You did not teach an eligible subject at #{eligible_school.name}.")

      click_on "I've tried all of my schools"

      expect(page).to have_text("You're not eligible for this payment")
    end
  end
end
