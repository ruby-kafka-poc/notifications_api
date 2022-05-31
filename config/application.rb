# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module CustomersApi
  class Application < Rails::Application
    config.load_defaults 7.0

    config.api_only = true

    Dir[File.expand_path('../lib/**/*.rb', __dir__)].each { |file| require file }
    config.middleware.use(KafkaRailsIntegration::Middlewares::DeliverMessages)
  end
end
