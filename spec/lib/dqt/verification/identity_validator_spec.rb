require "rails_helper"
require "dqt/verification/identity_validator"

RSpec.describe Dqt::Verification::IdentityValidator do

  let(:claim) { build(:claim, :unverified, eligibility: build(:maths_and_physics_eligibility)) }
  let(:api_record) do
    {
      :data => [
        {
          :teacher_reference_number=>"1000000",
          :first_name => "Jo",
          :surname => "Bloggs",
          :date_of_birth => "2001-03-31 00:00:00",
          :degree_codes => [],
          :national_insurance_number => "QQ100000C",
          :qts_award_date => "2021-03-23 10:54:57",
          :itt_subject_codes => [
            "G100",
            nil,
            nil
          ],
          :active_alert => true
        }
      ],
      :message => nil
    }
  end
  let(:record) { api_record[:data].first }
  let(:dqt_record_struct) do
    Struct.new(
      :trn,
      :first_name,
      :surname,
      :dob,
      :niNumber,
      :qtsAwardDate,
      :ittSubject1Code,
      :ittSubject2Code,
      :ittSubject3Code,
      :degree_codes,
      :activeAlert
    )
  end

  let(:dqt_record) do
    dqt_record_struct.new(
      record[:teacher_reference_number],
      record[:first_name],
      record[:surname],
      Date.parse(record[:date_of_birth]),
      record[:national_insurance_number],
      Date.parse(record[:qts_award_date]),
      record[:itt_subject_codes][0],
      record[:itt_subject_codes][1],
      record[:itt_subject_codes][2],
      record[:degree_codes],
      record[:active_alert]
    )
  end

  subject(:identity_validator) { Dqt::Verification::IdentityValidator.new(dqt_record: dqt_record, claim: claim) }

  it { is_expected.to be_an_instance_of Dqt::Verification::IdentityValidator }

  describe '#identity_verified?' do
    context 'when TRN and NI and NAME and DOB' do
      it 'returns "true" when all matched' do
        expect(subject.identity_verified?).to be true
      end
    end
  end
end

__END__

Identity Check Fields       | Match / Partial Match                  | Identity Verified | Notes                         | Send Email |
----------------------------+----------------------------------------+-------------------+-------------------------------+------------|
TRN AND NI                  | No match found                         | No                | Manual verification           | Yes        |
TRN AND NI AND Name AND DOB | All Matched                            | Yes               | No Notes entry                | No         |
TRN AND Name AND DOB        | All Matched except NI (Partial Match)  | Yes               | NI Not found or not matched   | No         |
NI AND Name AND DOB         | All Matched except TRN (Partial Match) | No                | TRN mismatches.               | No         |
                                                                                         | Manual correction carried out |            |
TRN AND NI AND  DOB         | All Match Except Name (Partial match)  | Yes               | Name not matched              | No         |
TRN AND NI AND Name         | All Match Except DOB (Partial match)   | Yes               | DOB not matched               | No         |
