# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailNotification, type: :model do
  let!(:prev_email_notification) { FactoryBot.create(:email_notification) }
  let(:email_notification) do
    EmailNotification.new(
      email: 'an@email.com',
      status: 'created',
      postmark_template: 'template',
      kafka_topic: 'a_topic',
      kafka_partition: 10
    )
  end

  it 'is valid with valid attributes' do
    expect(email_notification.valid?).to be_truthy
  end

  it 'is not valid without an email' do
    email_notification.assign_attributes(email: nil)
    expect(email_notification.valid?).to be_falsey
    expect(email_notification.errors.full_messages).to include("Email can't be blank")

    email_notification.assign_attributes(status: nil)
    expect(email_notification.valid?).to be_falsey
    expect(email_notification.errors.full_messages).to include("Status can't be blank")
  end

  it 'is not valid with a same partition and topic' do
    email_notification.assign_attributes(
      kafka_topic: prev_email_notification.kafka_topic,
      kafka_partition: prev_email_notification.kafka_partition
    )
    expect(email_notification.valid?).to be_falsey
    expect(email_notification.errors.full_messages).to include('Kafka topic and partition already exists')
  end
end
