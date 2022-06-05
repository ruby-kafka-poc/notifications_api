# frozen_string_literal: true

class ApplicationConsumer < KafkaRailsIntegration::Consumer
  def initialize
    puts "Starting #{self.class.name} consumer"
    super
    puts "#{self.class.name} consumer ready"
  end
end