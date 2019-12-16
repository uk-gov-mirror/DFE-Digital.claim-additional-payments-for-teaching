require "rails_helper"

RSpec.describe DfeSignIn::Api::User do
  describe "#all" do
    let(:users) { described_class.all }

    context "with one page" do
      before do
        stub_dfe_sign_in_user_list_request
      end

      it "gets all pages" do
        expect(users.count).to eq(3)
        expect(users.first.organisation_id).to eq("5b0e38fc-1db7-11ea-978f-2e728ce88125")
        expect(users.first.organisation_name).to eq("ACME Inc")
        expect(users.first.user_id).to eq("5b0e3686-1db7-11ea-978f-2e728ce88125")
        expect(users.first.given_name).to eq("Alice")
        expect(users.first.family_name).to eq("Example")
        expect(users.first.email).to eq("alice@example.com")

        expect(users.second.given_name).to eq("Bob")

        expect(users.third.given_name).to eq("Eve")
      end
    end

    context "with multiple pages" do
      let!(:first_page_stub) { stub_dfe_sign_in_user_list_request(number_of_pages: 3) }
      let!(:second_page_stub) { stub_dfe_sign_in_user_list_request(number_of_pages: 3, page_number: 2) }
      let!(:third_page_stub) { stub_dfe_sign_in_user_list_request(number_of_pages: 3, page_number: 3) }

      it "requests multiple pages" do
        expect(users.count).to eq(9)

        expect(first_page_stub).to have_been_requested
        expect(second_page_stub).to have_been_requested
        expect(third_page_stub).to have_been_requested
      end
    end
  end

  describe "#new" do
    subject { described_class.new(user_id: 999, organisation_id: 456) }

    let(:url) { "#{DfeSignIn.configuration.base_url}/services/#{DfeSignIn.configuration.client_id}/organisations/456/users/999" }

    before do
      stub_request(:get, url)
        .to_return(body: response.to_json, status: status)
    end

    context "with a valid response" do
      let(:status) { 200 }
      let(:response) do
        {
          "userId" => "999",
          "serviceId" => "123",
          "organisationId" => "456",
          "roles" => [
            {
              "id" => "role-id",
              "name" => "My role",
              "code" => "my_role",
              "numericId" => "9999",
              "status" => {
                "id" => 1,
              },
            },
          ],
          "identifiers" => [
            {
              "key" => "identifier-key",
              "value" => "identifier-value",
            },
          ],
        }
      end

      describe "has_role?" do
        let(:has_role?) { subject.has_role?(role) }

        context "when a role exists" do
          let(:role) { "my_role" }
          it { expect(has_role?).to eq(true) }
        end

        context "when a role does not exist" do
          let(:role) { "other_role" }
          it { expect(has_role?).to eq(false) }
        end
      end

      describe "#role_codes" do
        it "returns the role codes" do
          expect(subject.role_codes).to eq(["my_role"])
        end
      end
    end

    context "with an invalid response" do
      let(:status) { 500 }
      let(:response) { {"error": "An error occurred"} }

      describe "has_role?" do
        it "raises an error" do
          expect { subject.has_role?("my_role") }.to raise_error(
            DfeSignIn::ExternalServerError, "500: {\"error\":\"An error occurred\"}"
          )
        end
      end
    end
  end
end
