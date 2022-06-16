# frozen_string_literal: true

class ApplicationConsumer < Karafka::BaseConsumer
  # TODO: NOT HERE! 😡
  DEFAULT_TENANT = 'default'

  attr_reader :base_template, :template, :topic, :partition

  def initialize(topic)
    super
    self.topic = topic
  end

  def consume
    messages.each { |m| receive(m) }
  end

  def receive(message)
    Rails.logger.debug do
      "Message Received: offset #{message.offset}, key #{message.key}, value #{message.raw_payload}"
    end
    register_model!(
      message.raw_payload.with_indifferent_access,
      message.partition
    )
  end

  private

  def register_model!(payload, partition)
    object = payload[:object] || {}
    EmailNotification.create!(
      tenant: payload[:tenant],
      organization_id: payload[:organization_id],
      email: object[:email],
      postmark_template: template,
      state: :created,
      kafka_partition: partition, kafka_topic: topic,
      args: object
    )
  end

  def email_client
    @email_client ||= PostmarkClient.new
  end
end
