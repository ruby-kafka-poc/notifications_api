# frozen_string_literal: true

class ApplicationConsumer < Karafka::BaseConsumer
  # TODO: NOT HERE! 😡
  DEFAULT_TENANT = 'default'

  attr_accessor :base_template

  def consume
    messages.each do |m|
      begin
        receive(m)
      rescue Exception => e
        Rails.logger.error e.message
      end
    end
  end

  def receive(message)
    log_receive(message) do
      template = defined_template(message.payload.with_indifferent_access)
      model = register_model(message, template)

      if model.valid?
        resp = email_client.deliver(template, model.email, model.args)
        update_status(model, resp)
      end

      model
    end
  end

  private

  def defined_template(payload)
    email_client.templates(
      base_template,
      payload[:organization_id],
      payload[:tenant] || DEFAULT_TENANT
    ).last
  end

  def register_model(message, template)
    payload = message.payload.with_indifferent_access
    object = payload[:object] || {}
    EmailNotification.create(
      tenant: payload[:tenant] || DEFAULT_TENANT,
      organization_id: payload[:organization_id],
      email: object[:email],
      postmark_template: template,
      status: :created,
      kafka_offset: message.offset, kafka_topic: topic.name,
      args: object
    )
  end

  def update_status(model, resp)
    case resp.status
    when :sent
      model.update(status: :sent, postmark_message_id: resp.message_id)
    else
      model.update(
        status: :failed_to_send,
        postmark_message_id: resp.message_id,
        error_description: "Error `#{resp.error_code}`: #{resp.message}"
      )
    end
  end

  def email_client
    @email_client ||= PostmarkClient.new
  end

  def log_receive(message)
    Thread.current.thread_variable_set(:receive_message_id, SecureRandom.hex(6))

    Rails.logger.debug do
      <<~EOS.squish
        [consumer] (#{Thread.current.thread_variable_get(:receive_message_id)})
        Message Received: offset #{message.offset}, key #{message.key}, value #{message.raw_payload}
      EOS
    end

    yield.tap do |model|
      Rails.logger.debug do
        <<~EOS.squish
          [consumer] (#{Thread.current.thread_variable_get(:receive_message_id)})
          skipping, repeated message? #{model.errors.full_messages}
        EOS
      end unless model.valid?
    end
  end
end
