module Dqt
  module Verification
    class IdentityValidator
      def initialize(dqt_record:, claim:)
        @record = dqt_record
        @claim = claim
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
