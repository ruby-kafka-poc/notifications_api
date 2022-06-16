# frozen_string_literal: true

require 'postmark'

class PostmarkClient
  def deliver(code, to, options = {})
    raise PostmarkError, '`to` is required' unless to
    raise PostmarkError, '`code` is required' unless code

    client.deliver_with_template(
      from:,
      to:,
      template_alias: code,
      template_model: options
    )
  end

  def templates(code, organization_id, tenant = 'default')
    client.get_templates[1]
          .pluck(:alias)
          .select do |t|
      t == code ||
        t == "#{tenant}-#{code}" ||
        (organization_id && t == "#{tenant}-#{organization_id}-#{code}")
    end.sort
  end

  private

  def from
    @from ||= ENV.fetch('POSTMARK_FROM', nil)
  end

  def client
    @client ||= Postmark::ApiClient.new(ENV.fetch('POSTMARK_API_KEY', nil))
  end
end
