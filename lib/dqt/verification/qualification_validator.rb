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
        valid_award_date? && valid_claim_year?
      end

      def valid_award_date?
        record.qtsAwardDate.present?
      end

      def valid_claim_year?
        AcademicYear.for(record.qtsAwardDate) >= StudentLoans.first_eligible_qts_award_year
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

### ECP

| QTS Check Field               | Match / Partial Match | QTS Verified | Notes                                |
|+++++++++++++++++++++++++++++++|+++++++++++++++++++++++|++++++++++++++|++++++++++++++++++++++++++++++++++++++|
| dfeta_qtsdate AND ITTSubjects | Match                 | Yes          | No Notes entry                       |
| dfeta_qtsdate                 | Partial match         | No           | ITT Subjects OR                      | 
|                               |                       |              | Undergraduate Subjects doesn’t match |
| ITT Subjects                  | Partial match         | No           | ITT Award date not matched.          |
|                               |                       |              | Qualified at x date.                 |

| IIT Subjects Name     | IIT Subjects                 | Notes                              |
|+++++++++++++++++++++++|++++++++++++++++++++++++++++++|++++++++++++++++++++++++++++++++++++|
| Mathematics           | G100 or 100403               |                                    |
| Physics               | F300 or 100425               |                                    |
| Chemistry             | F100 or 100417               |                                    |
| Computer Science      | I100 or 100366               |                                    |
| Other Modern Language | R900 or R400 or R200 or R100 | Languages could be recorded in DQT |
|                       |                              | as Spanish or French or German     |
|                       |                              | R900 - Other Modern language       |
|                       |                              | R400 - Spanish                     |
|                       |                              | R200 - German                      |
|                       |                              | R100 - French                      |

QTS Date match criteria

The QTS should be in the eligible academic year(For example, to claim in AY 2021/22, the QTS award date should be in AY 2018/19 for UG and for PG they should have started the ITT course in 2018/19 and QTS awarded before they submit the claim for them to be eligible). 

QTS Date Criteria is explained in the below tables

The Academic Year starts from 1st September to 31st August

The ECP QTS eligibility criteria could be found here. 



| Cohort | UG ITT Completed / | Eligible Cohort |    AY     |    AY     |    AY     |    AY     |
|        | QTS Award Year     | ITT Subjects    | 2021/2022 | 2022/2023 | 2023/2024 | 2024/2025 |
|++++++++|++++++++++++++++++++|+++++++++++++++++|+++++++++++|+++++++++++|+++++++++++|+++++++++++|
| 1      | 2018/2019          | Mathematics     | Eligible  | NEligible | Eligible  | NEligible |
| 2      | 2019/2020          | Mathematics     | NEligible | Eligible  | NEligible | Eligible  |
| 3      | 2020/2021          | Mathematics     | NEligible | Eligible  | Eligible  | Eligible  |
|        |                    | Physics         |
|        |                    | Chemistry       |
|        |                    | Other Modern    |
|        |                    | Languages       |


| Cohort | PG ITT Started     | Eligible Cohort |    AY     |    AY     |    AY     |    AY     | PG QTS Award Yr |
|        | Yr                 | ITT Subjects    | 2021/2022 | 2022/2023 | 2023/2024 | 2024/2025 |                 |
|++++++++|++++++++++++++++++++|+++++++++++++++++|+++++++++++|+++++++++++|+++++++++++|+++++++++++|+++++++++++++++++|
| 1      | 2018/2019          | Mathematics     | Eligible  | NEligible | Eligible  | NEligible | 2018/2019 OR    |
|        |                    |                 |           |           |           |           | 2019/2020 OR    |
|        |                    |                 |           |           |           |           | 2020/2021       |
| 2      | 2019/2020          | Mathematics     | NEligible | Eligible  | NEligible | Eligible  | 2019/2020 OR    |
|        |                    |                 |           |           |           |           | 2020/2021       |
| 3      | 2020/2021          | Mathematics     | NEligible | Eligible  | Eligible  | Eligible  | 2020/2021       |
|        |                    | Physics         |           |           |           |           |                 |
|        |                    | Chemistry       |           |           |           |           |                 |
|        |                    | Other Modern    |           |           |           |           |                 |
|        |                    | Languages       |           |           |           |           |                 |


QTS / undergraduate Subject match criteria

If the code is JAC code it needs to start with the relevant subject JAC code and if it a HeCos code then it has to completely match with the relevant subject HeCos code. All JAC and HeCos subject codes can be found here.




### TSLR

TSLR
| QTS Check Field               | Match / Partial Match | QTS Verified | Notes                                |
|+++++++++++++++++++++++++++++++|+++++++++++++++++++++++|++++++++++++++|++++++++++++++++++++++++++++++++++++++|
| dfeta_qtsdate                 | Match                 | Yes          | No notes                             |
|                               |                       |              | Qualified at x date.                 |


## Additional Notes (TSLR)
QTS Date match criteria

### Check in existing code to see if we do the 10 year bit!!!
The claimant can claim up to 10 years since he/she graduated from 1st September 2013/2014. The Academic Year starts from 1st September to 31st August. For examples 
The claimant graduated on 01/09/2013 then they are eligible to claim between 01/09/2013 to 31/08/2023 for the eligible academic year.
The claimant graduated on 01/09/2015 then they are eligible to claim between 01/09/2015 to 31/08/2025 for the eligible academic year.
The claimant graduated on 01/09/2012 then they are NOT eligible to claim because starting QTS date for claim eligibility must be from 01/09/2013.

======================
DqTReportConsumer record
Hash
{:claim_reference=>"ZY987654", :qts_date=>Sat, 20 May 2017, :surname=>"Hecos", :date_of_birth=>Tue, 08 Jan 1991, :degree_codes=>["100405"], :itt_subject_codes=>["101027"]}