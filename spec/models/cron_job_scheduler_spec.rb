require "rails_helper"

RSpec.describe CronJobScheduler, type: :model do
  def queue_adapter_for_test
    DelayedJobTestAdapter.new
  end

  it "schedules SchoolDataImporterJob" do
    expect {
      described_class.new.schedule
    }.to change {
      Delayed::Job
        .where("handler LIKE ?", "%job_class: SchoolDataImporterJob%")
        .count
    }.by(1)
  end

  it "schedules UserDataImporterJob" do
    expect {
      described_class.new.schedule
    }.to change {
      Delayed::Job
        .where("handler LIKE ?", "%job_class: UserDataImporterJob%")
        .count
    }.by(1)
  end
end
