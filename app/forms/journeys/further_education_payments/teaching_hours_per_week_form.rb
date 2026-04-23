module Journeys
  module FurtherEducationPayments
    class TeachingHoursPerWeekForm < Form
      attribute :teaching_hours_per_week, :string

      validates :teaching_hours_per_week,
        inclusion: {
          in: ->(form) { form.radio_options.map(&:id) },
          message: i18n_error_message(:inclusion)
        }

      def radio_options
        @radio_options ||= [
          Option.new(
            id: TEACHING_HOURS_MORE_THAN_20,
            name: t("options.more_than_20")
          ),
          Option.new(
            id: TEACHING_HOURS_MORE_THAN_12,
            name: t("options.more_than_12")
          ),
          Option.new(
            id: TEACHING_HOURS_BETWEEN_TWO_POINT_5_AND_12,
            name: t("options.between_2_5_and_12")
          ),
          Option.new(
            id: TEACHING_HOURS_LESS_THAN_TWO_POINT_5,
            name: t("options.less_than_2_5")
          )
        ]
      end

      def save
        return false unless valid?

        journey_session.answers.assign_attributes(teaching_hours_per_week:)
        journey_session.save!
      end

      def clear_answers_from_session
        journey_session.answers.assign_attributes(teaching_hours_per_week: nil)
        journey_session.save!
      end

      def school
        journey_session.answers.school
      end
    end
  end
end
