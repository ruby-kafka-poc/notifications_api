# frozen_string_literal: true

require 'postmark'

class PostmarkClient
  def deliver(template_alias, to, options = {})
    client.deliver_with_template(
      from: ENV.fetch('POSTMARK_FROM', nil),
      to:,
      template_alias: template_alias,
      template_model: options
    )
  end

  def client
    @client ||= Postmark::ApiClient.new(ENV.fetch('POSTMARK_API_KEY', nil))
  end
end
