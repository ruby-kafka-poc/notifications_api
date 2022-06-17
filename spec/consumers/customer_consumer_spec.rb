# frozen_string_literal: true

require 'rails_helper'
# require 'karafka'
# require 'debug'
require_relative '../../app/consumers/application_consumer'

describe 'CustomerCreatedConsumer' do
  let(:rails) { double('Rails') }
  let(:logger) { double('Logger') }
  let(:email_client) { double('PostmarkClient') }
  let(:topic) do
    Karafka::Routing::Topic.new(
      'topic',
      Karafka::Routing::ConsumerGroup.new('group')
    )
  end
  subject { CustomerCreatedConsumer.new }

  before do
    allow(logger).to receive(:debug)
    allow(logger).to receive(:error)
    allow(Rails).to receive(:logger).and_return(logger)
    allow(email_client).to receive(:templates).and_return(['test-email1'])
    allow(email_client).to receive(:deliver).and_return(PostmarkResponse.new('1', :sent, nil, nil))
    allow(subject).to receive(:topic).and_return(topic)
    allow(subject).to receive(:email_client).and_return(email_client)
    allow(subject).to receive(:messages).and_return(
      [
        Karafka::Messages::Message.new(
          '{"entity": "Customer", "object":  {"id": 9, "email": "a@b.com", "action": "created"}}',
          Karafka::Messages::Metadata.new(
            offset: 0,
            partition: 0,
            deserializer: Karafka::Serialization::Json::Deserializer.new,
            topic:
          )
        )
      ]
    )
  end

  context '#consume' do
    before do
      subject.consume
    end

    it 'succeeds' do
      expect(EmailNotification.count).to eq(1)
      expect(EmailNotification.first.status).to eq('sent')
      expect(EmailNotification.first.postmark_template).to eq('test-email1')
    end
  end
end
