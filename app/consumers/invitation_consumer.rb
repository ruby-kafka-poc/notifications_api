# frozen_string_literal: true

class InvitationConsumer < ApplicationConsumer
  def initialize
    self.topic = 'customer_created'
    super
  end

  def consume
    # debugger
  end
end

# https://github.com/ayyoubjadoo/Karafka-Example/blob/master/app/consumers/callbacked_consumer.rb
# https://github.com/ayyoubjadoo/Karafka-Example/blob/master/app/consumers/inline_batch_consumer.rb
