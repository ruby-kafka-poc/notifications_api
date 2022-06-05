#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

require "#{root}/app/consumers/application_consumer"
require "#{root}/app/consumers/customer_created_consumer"

KafkaRailsIntegration.configure_with('./kafka.yml')

$running = true
Signal.trap("TERM") do
  $running = false
end

while($running) do

  # Replace this with your code
  Rails.logger.info "This daemon CustomerCreated is still running at #{Time.now}.\n"
  CustomerCreatedConsumer.new
end
