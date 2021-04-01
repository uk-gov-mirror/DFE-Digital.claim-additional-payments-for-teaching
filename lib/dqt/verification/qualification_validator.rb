module Dqt
  module Verification
    class QualificationValidator
      def initialize(dqt_record:)
        @record = dqt_record
      end

      def qualification_verified?
        eligible_qts_date?
      end

      private

      attr_reader :record

      def eligible_qts_date?
        record.qtsAwardDate.present?
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