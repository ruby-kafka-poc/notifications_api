# frozen_string_literal: true

class CustomerCreatedConsumer < ApplicationConsumer
  def initialize(topic)
    super
    self.base_template = 'test-email1'
  end

  def receive(message)
    define_template!(message.raw_payload.with_indifferent_access)
    model = super
    client.deliver(template, model.email, model.args) if template

    model
  end

  private

  def define_template!(payload)
    self.template = client.templates(
      base_template,
      payload[:organization_id],
      payload[:tenant] || DEFAULT_TENANT
    ).last
  end
end
