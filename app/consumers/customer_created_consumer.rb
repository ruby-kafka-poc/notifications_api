# frozen_string_literal: true

class CustomerCreatedConsumer < ApplicationConsumer
  def initialize
    super
    self.base_template = 'test-email1'
  end
end
