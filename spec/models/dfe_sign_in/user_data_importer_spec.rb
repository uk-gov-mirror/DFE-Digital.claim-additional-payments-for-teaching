require "rails_helper"

RSpec.describe DfeSignIn::UserDataImporter, type: :model do
  before { stub_dfe_sign_in_user_list_request }

  it "imports all user data" do
    DfeSignIn::UserDataImporter.new.run

    expect(DfeSignIn::User.count).to eq(3)
  end

  context "when a user already exists" do
    let!(:existing_user) { create(:dfe_signin_user, id: "5b0e3686-1db7-11ea-978f-2e728ce88125") }

    it "updates the user" do
      DfeSignIn::UserDataImporter.new.run

      expect(DfeSignIn::User.count).to eq(3)

      existing_user.reload

      expect(existing_user.given_name).to eq("Alice")
      expect(existing_user.family_name).to eq("Example")
      expect(existing_user.email).to eq("alice@example.com")
      expect(existing_user.organisation_name).to eq("ACME Inc")
    end
  end
end
