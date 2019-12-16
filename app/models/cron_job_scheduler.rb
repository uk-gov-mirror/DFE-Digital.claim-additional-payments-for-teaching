class CronJobScheduler
  def initialize
    Dir.glob(glob).each { |f| require f }
  end

  def schedule
    CronJob.subclasses.each { |job| job.schedule }
  end

  def glob
    Rails.root.join("app", "jobs", "**", "*_job.rb")
  end
end
