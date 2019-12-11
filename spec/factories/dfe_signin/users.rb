FactoryBot.define do
  factory :dfe_signin_user, class: "DfeSignIn::User" do
    given_name { "Jo" }
    family_name { "Bloggs" }
    email { "jo.bloggs@education.gov.uk" }
    organisation_name { "Department for Education" }
  end
end
