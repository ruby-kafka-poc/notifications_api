# frozen_string_literal: true

class OrderCreatedConsumer < Application
  group_id :a
  topic :order_created

  def consume(message)
    Rails.logger.debug { "offset #{message.offset}, key #{message.key}, value #{message.value}" }
  end
end

# https://github.com/ayyoubjadoo/Karafka-Example/blob/master/app/consumers/callbacked_consumer.rb
