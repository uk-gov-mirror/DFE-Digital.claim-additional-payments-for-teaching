require "rails_helper"

RSpec.feature "Service maintenance" do
  scenario "Service operator puts a service into maintenance mode with a message" do
    sign_in_to_admin_with_role(AdminSession::SERVICE_OPERATOR_DFE_SIGN_IN_ROLE_CODE)

    click_on "Maintenance"

    expect(page).to have_content("Teachers: claim back your student loan repayments")
    within("table") do
      expect(page).to have_content("Open")
      expect(page).not_to have_content("Closed")
    end

    click_on "Change"

    fill_in "Availability message", with: "You will be able to make a claim when the service enters public beta in November."

    within_fieldset("Service status") { choose("Closed") }

    click_on "Save"

    expect(current_url).to eq(admin_policy_configurations_url)

    within("table") do
      expect(page).to have_content("Closed")
      expect(page).not_to have_content("Open")
    end

    expect(policy_configurations(:student_loans).maintenance_mode).to be true
    expect(policy_configurations(:student_loans).maintenance_mode_availability_message).to eq("You will be able to make a claim when the service enters public beta in November.")
  end

  scenario "Service operator takes a service out of maintenance mode" do
    policy_configurations(:student_loans).update(maintenance_mode: true)

    sign_in_to_admin_with_role(AdminSession::SERVICE_OPERATOR_DFE_SIGN_IN_ROLE_CODE)

    click_on "Maintenance"

    expect(page).to have_content("Teachers: claim back your student loan repayments")
    within("table") do
      expect(page).to have_content("Closed")
      expect(page).not_to have_content("Open")
    end

    click_on "Change"

    within_fieldset("Service status") { choose("Open") }

    click_on "Save"

    expect(current_url).to eq(admin_policy_configurations_url)

    within("table") do
      expect(page).to have_content("Open")
      expect(page).not_to have_content("Closed")
    end

    expect(policy_configurations(:student_loans).reload.maintenance_mode).to be false
  end
end
