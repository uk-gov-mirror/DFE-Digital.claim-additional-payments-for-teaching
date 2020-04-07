if ENV["LOGSTASH_HOST"].present?
  Rails.application.configure do
    SemanticLogger.add_appender(io: $stdout, formatter: :json)
  end
end
