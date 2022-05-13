# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:example) do
    allow_any_instance_of(Postmark::ApiClient).to receive(:deliver_with_template)
  end
end
