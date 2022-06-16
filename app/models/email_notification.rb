# frozen_string_literal: true

class EmailNotification < ApplicationRecord
  validates :email, :status, :postmark_template, :kafka_topic, :kafka_partition, presence: true
  validates :kafka_topic, uniqueness: {
    scope: :kafka_partition,
    message: 'and partition already exists'
  }
end
