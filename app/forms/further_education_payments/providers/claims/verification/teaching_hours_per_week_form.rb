module FurtherEducationPayments
  module Providers
    module Claims
      module Verification
        class TeachingHoursPerWeekForm < BaseForm
          TEACHING_HOURS_PER_WEEK_OPTIONS = [
            Form::Option.new(
              id: TEACHING_HOURS_MORE_THAN_20,
              name: I18n.t(
                %w[
                  further_education_payments_provider
                  forms
                  verification
                  provider_verification_teaching_hours_per_week
                  options
                  more_than_20
                ].join(".")
              )
            ),
            Form::Option.new(
              id: TEACHING_HOURS_MORE_THAN_12,
              name: I18n.t(
                %w[
                  further_education_payments_provider
                  forms
                  verification
                  provider_verification_teaching_hours_per_week
                  options
                  more_than_12
                ].join(".")
              )
            ),
            Form::Option.new(
              id: TEACHING_HOURS_BETWEEN_TWO_POINT_5_AND_12,
              name: I18n.t(
                %w[
                  further_education_payments_provider
                  forms
                  verification
                  provider_verification_teaching_hours_per_week
                  options
                  between_2_5_and_12
                ].join(".")
              )
            ),
            Form::Option.new(
              id: TEACHING_HOURS_LESS_THAN_TWO_POINT_5,
              name: I18n.t(
                %w[
                  further_education_payments_provider
                  forms
                  verification
                  provider_verification_teaching_hours_per_week
                  options
                  less_than_2_5
                ].join(".")
              )
            )
          ]

          attribute :provider_verification_teaching_hours_per_week, :string

          validates(
            :provider_verification_teaching_hours_per_week,
            included: {
              in: ->(form) do
                form.provider_verification_teaching_hours_per_week_options.map(&:id)
              end,
              message: ->(form, _) do
                "Select how many hours #{form.claimant_name} was timetabled to " \
                "teach at #{form.provider_name} during the spring term"
              end
            },
            allow_nil: :save_and_exit?
          )

          def provider_verification_teaching_hours_per_week_options
            TEACHING_HOURS_PER_WEEK_OPTIONS
          end

          def claimant_term
            claim.submitted_at.term
          end

          def school
            claim.school
          end
        end
      end
    end
  end
end
