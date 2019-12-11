require "rails_helper"

RSpec.describe DfeSignIn::User, type: :model do
  it { should validate_presence_of(:given_name) }
  it { should validate_presence_of(:family_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:organisation_name) }
end
