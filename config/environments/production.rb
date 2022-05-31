# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.log_level = :info
  config.log_tags = [:request_id]
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  Rails.logger = Logger.new($stdout)
  config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")

  KafkaRailsIntegration.configure_with('./config/kafka.yml')
  config.active_record.dump_schema_after_migration = false
end
