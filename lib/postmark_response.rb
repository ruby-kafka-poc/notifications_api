# frozen_string_literal: true

class PostmarkResponse
  attr_reader :message_id, :status, :error_code, :message

  def initialize(message_id, status, error_code, message)
    @message_id = message_id
    @status = status
    @error_code = error_code
    @message = message
  end

  def self.from_api(response)
    PostmarkResponse.new(
      response[:message_id],
      response[:error_code] == 0 ? :sent : :failed,
      response[:error_code],
      response[:message]
    )
  end
end
