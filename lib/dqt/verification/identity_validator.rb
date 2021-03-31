module Dqt
  module Verification
    class IdentityValidator
      def initialize(dqt_record:, claim:)
        @record = dqt_record
        @claim = claim
      end

      def identity_verified?
        return false if no_match?
        return true if all_matched?
        partial_match?
      end

      private

      attr_reader :record, :claim

      def all_matched?
        trn_matched? &&
          national_insurance_number_matched? &&
          name_matched? &&
          dob_matched?
      end

      def partial_match?
        return true if trn_matched? && name_matched? && dob_matched?

        return true if trn_matched? && national_insurance_number_matched? && dob_matched?

        return true if trn_matched? && national_insurance_number_matched? && name_matched?

        return false if national_insurance_number_matched? && name_matched? & dob_matched?
      end

      def no_match?
        !trn_matched? && !national_insurance_number_matched?
      end

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
