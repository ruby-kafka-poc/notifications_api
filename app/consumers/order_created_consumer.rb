# frozen_string_literal: true

class OrderCreatedConsumer < ApplicationConsumer
  def initialize
    super
    self.base_template = 'test-email-orders'
  end
end
