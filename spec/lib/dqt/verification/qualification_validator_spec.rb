require "rails_helper"
require "dqt/verification/qualification_validator"

RSpec.describe Dqt::Verification::QualificationValidator do
  let(:dqt_dob) { 25.years.ago.to_s }
  let(:api_record) do
    {
      data: [
        {
          teacher_reference_number: "2015239",
          first_name: "Sarah",
          surname: "Ashburton",
          date_of_birth: dqt_dob,
          degree_codes: [],
          national_insurance_number: "AT200079E",
          qts_award_date: "2019-06-30 16:34:57",
          itt_subject_codes: [
            "G100",
            nil,
            nil
          ],
          active_alert: true
        }
      ],
      message: nil
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

  subject(:qualification_validator) { Dqt::Verification::QualificationValidator.new(dqt_record: dqt_record) }

  it { is_expected.to be_an_instance_of Dqt::Verification::QualificationValidator }

  describe "#qualification_verified?" do
    context "when partial match it returns 'false'" do
      it "has matched ONLY 'qts_date'" do
        expect(subject.qualification_verified?).to be false
      end
    end
  end
end

__END__

Qualification check
The Qualification check will verify the teacher's QTS award date, ITT and Undergraduate subjects(Subject name or HeCos / JAC Codes).
ITT Subjects:
 - ITTSub1Value
 - ITTSub2Value
 - ITTSub3Value

TSLR
| QTS Check Field               | Match / Partial Match | QTS Verified | Notes                                |
|+++++++++++++++++++++++++++++++|+++++++++++++++++++++++|++++++++++++++|++++++++++++++++++++++++++++++++++++++|
| dfeta_qtsdate AND ITTSubjects | Match                 | Yes          | No Notes entry                       |
| dfeta_qtsdate                 | Partial match         | No           | ITT Subjects Subjects doesn't match  |
| ITT Subjects                  | Partial match         | No           | ITT Award date not matched.          |
|                               |                       |              | Qualified at x date.                 |

N.B. IIT Subjects codes need to confirm from DQT.
| IIT Subjects Name     | IIT Subjects                 | Notes                              |
|+++++++++++++++++++++++|++++++++++++++++++++++++++++++|++++++++++++++++++++++++++++++++++++|
| Biology               | C100 or 100346               |                                    |
| Physics               | F300 or 100425               |                                    |
| Chemistry             | F100 or 100417               |                                    |
| Computer Science      | I100 or 100366               |                                    |
| Other Modern Language | R900 or R400 or R200 or R100 | Languages could be recorded in DQT |
|                       |                              | as Spanish or French or German     |
|                       |                              | R900 - Other Modern language       |
|                       |                              | R400 - Spanish                     |
|                       |                              | R200 - German                      |
|                       |                              | R100 - French                      |
Additional Notes (TSLR)
QTS Date match criteria
The claimant can claim up to 10 years since he/she graduated from 1st September 2013/2014. The Academic Year starts from 1st September to 31st August. For examples 
The claimant graduated on 01/09/2013 then they are eligible to claim between 01/09/2013 to 31/08/2023 for the eligible academic year.
The claimant graduated on 01/09/2015 then they are eligible to claim between 01/09/2015 to 31/08/2025 for the eligible academic year.
The claimant graduated on 01/09/2012 then they are NOT eligible to claim because starting QTS date for claim eligibility must be from 01/09/2013.

======================
DqTReportConsumer record
Hash
{:claim_reference=>"ZY987654", :qts_date=>Sat, 20 May 2017, :surname=>"Hecos", :date_of_birth=>Tue, 08 Jan 1991, :degree_codes=>["100405"], :itt_subject_codes=>["101027"]}