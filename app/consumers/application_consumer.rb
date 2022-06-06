# frozen_string_literal: true

class ApplicationConsumer < KafkaRailsIntegration::Consumer
  def initialize
    Rails.logger.debug { "Starting #{self.class.name} consumer" }
    super
    Rails.logger.debug { "#{self.class.name} consumer ready" }
  end
end
