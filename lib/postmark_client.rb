# frozen_string_literal: true

require 'postmark'

class PostmarkClient
  def deliver(code, to, options = {})
    raise PostmarkError, '`to` is required' unless to
    raise PostmarkError, '`code` is required' unless code

    response = deliver_log(code, from, to, options) do
      begin
        client.deliver_with_template(
          from:, to:,
          template_alias: code,
          template_model: options
        )
      rescue Postmark::ApiInputError => e
        { error_code: 1, message: e.message }
      rescue Postmark::InactiveRecipientError => e
        { error_code: 1, message: e.message }
      end
    end

    PostmarkResponse.from_api(response)
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

  def deliver_log(code, from, to, options)
    Rails.logger.debug do
      <<~EOS.squish
          [email_delivery] (#{Thread.current.thread_variable_get(:receive_message_id)})
          Delivering email: '#{code}' from '#{from}', to '#{to}', args #{options}
      EOS
    end

    response = yield

    Rails.logger.debug do
      <<~EOS.squish
          [email_delivery] (#{Thread.current.thread_variable_get(:receive_message_id)})
          Delivered email: #{response[:error_code]}-#{response[:message]}
      EOS
    end

    response
  end
end
