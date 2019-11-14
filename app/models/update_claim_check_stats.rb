require "geckoboard"

class UpdateClaimCheckStats
  DATASET_FIELDS = [
    Geckoboard::StringField.new(:metric, name: "Metric"),
    Geckoboard::NumberField.new(:count, name: "Count"),
  ]

  def perform
    dataset.put([
      {
        metric: "AwaitingChecking",
        count: Claim.awaiting_checking.count,
      },
      {
        metric: "PassedCheckDeadline",
        count: Claim.passed_check_deadline.count,
      },
    ])
  end

  private

  def client
    @client ||= Geckoboard.client(ENV["GECKOBOARD_API_KEY"])
  end

  def dataset
    client.datasets.find_or_create(dataset_name, fields: DATASET_FIELDS)
  end

  def dataset_name
    [
      "claims",
      "metrics",
      ENV["ENVIRONMENT_NAME"],
    ].join(".")
  end
end
