#!/usr/bin/env ruby
# frozen_string_literal: true

# You might want to change this
ENV['RAILS_ENV'] ||= 'production'

root = __dir__
root = File.dirname(root) until File.exist?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, 'config', 'environment')

require "#{root}/app/consumers/application_consumer"
require "#{root}/app/consumers/customer_created_consumer"

KafkaRailsIntegration.configure_with('./kafka.yml')

# rubocop:disable Style/GlobalVars
$running = true
Signal.trap('TERM') do
  $running = false
end

while $running

  # Replace this with your code
  Rails.logger.info "This daemon CustomerCreated is still running at #{Time.zone.now}.\n"
  CustomerCreatedConsumer.new
end
# rubocop:enable Style/GlobalVars
