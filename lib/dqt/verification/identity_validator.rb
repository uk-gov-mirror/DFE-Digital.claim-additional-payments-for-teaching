module Dqt
  module Verification
    class IdentityValidator
      def initialize(dqt_record:, claim:)
        @record = dqt_record
        @claim = claim
      end

      def identity_verified?
        trn_matched? &&
        national_insurance_number_matched? &&
        name_matched? &&
        dob_matched?
      end

      private

      attr_reader :record, :claim

      def trn_matched?
        claim.teacher_reference_number == record.trn
      end

      def national_insurance_number_matched?
        claim.national_insurance_number == record.niNumber
      end

      def name_matched?
        claim.surname == record.surname && claim.first_name == record.first_name
      end

      def dob_matched?
        claim.date_of_birth == record.dob
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
TRN AND NI AND DOB          | All Match Except Name (Partial match)  | Yes               | Name not matched              | No         |
TRN AND NI AND Name         | All Match Except DOB (Partial match)   | Yes               | DOB not matched               | No         |
