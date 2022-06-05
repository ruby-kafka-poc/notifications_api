# frozen_string_literal: true

class OrderCreatedConsumer < Application
  group_id :a
  topic :order_created

  def consume(message)
    # #<Kafka::FetchedMessage:0x000000010a4ee930
    # @message=
    #   #<Kafka::Protocol::Record:0x000000010a4e49d0
    #   @attributes=0,
    #     @bytesize=218,
    #     @create_time=2022-05-28 17:34:01.141 -0300,
    #   @headers={},
    #     @is_control_record=false,
    #     @key=nil,
    #     @offset=0,
    #     @offset_delta=0,
    #     @timestamp_delta=0,
    #     @value=
    #       "{\"entity\":\"Order\",\"object\":{\"id\":31,\"name\":\"Theron Metz\",\"last_name\":\"Zulauf\",\"email\":\"selma.smith@hermiston.name\",\"created_at\":\"2022-05-28T20:34:01.126Z\",\"updated_at\":\"2022-05-28T20:34:01.126Z\"},\"action\":\"created\"}">,
    #     @partition=0,
    #     @topic="order_created">
    #
    puts("offset #{message.offset}, key #{message.key}, value #{message.value}")
  end
end

# https://github.com/ayyoubjadoo/Karafka-Example/blob/master/app/consumers/callbacked_consumer.rb
