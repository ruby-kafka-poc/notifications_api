# frozen_string_literal: true

class ApplicationConsumer < Karafka::BaseConsumer
  # TODO: NOT HERE! 😡
  DEFAULT_TENANT = 'default'

  attr_accessor :base_template

  def consume
    messages.each do |m|
      receive(m)
    rescue StandardError => e
      raise if Rails.env.test?

      Rails.logger.error e.message
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
    payload = message.payload.with_indifferent_access.transform_keys(&:downcase) || {}

    model = EmailNotification.new(
      tenant: payload[:tenant] || DEFAULT_TENANT,
      organization_id: payload[:organization_id],
      email: payload[:email],
      postmark_template: template,
      kafka_offset: message.offset, kafka_topic: topic.name,
      status: :created, args: payload
    )

    log_error(model) unless model.valid?
    model.save!
    model
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
      <<~MSG.squish
        [consumer] (#{Thread.current.thread_variable_get(:receive_message_id)})
        Message Received: offset #{message.offset}, key #{message.key}, value #{message.raw_payload}
      MSG
    end

    yield.tap { |model| log_error(model) }
  end

  def log_error(model)
    return if model.valid?

    Rails.logger.debug do
      <<~MSG.squish
        [consumer] (#{Thread.current.thread_variable_get(:receive_message_id)})
        skipping, repeated message? #{model.errors.full_messages}
      MSG
    end
  end
end
