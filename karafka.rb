# frozen_string_literal: true

require ::File.expand_path('config/environment', __dir__)
Rails.application.eager_load!

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = {
      'bootstrap.servers': KafkaRailsIntegration.config[:bootstrap_servers],
      'security.protocol': KafkaRailsIntegration.config[:security_protocol],
      'sasl.mechanism': KafkaRailsIntegration.config[:sasl_mechanism],
      'sasl.username': KafkaRailsIntegration.config[:sasl_username],
      'sasl.password': KafkaRailsIntegration.config[:sasl_password]
    }
    config.client_id = SecureRandom.uuid
    config.concurrency = 2
    config.max_wait_time = 500 # 0.5 second
    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
    # config.kafka.start_from_beginning = true
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(Karafka.logger)
  )

  unless Rails.env.test?
    routes.draw do
      # This needs to match queues defined in your ActiveJobs
      active_job_topic :default

      topic 'pksqlc-q9jvmCUSTOMER_CREATED' do
        consumer CustomerCreatedConsumer
      end

      topic 'pksqlc-q9jvmORDERS_CREATED' do
        consumer OrderCreatedConsumer
      end
    end
  end
end
