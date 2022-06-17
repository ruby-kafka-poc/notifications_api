# frozen_string_literal: true

class EmailNotification < ApplicationRecord
  validates :email, :status, :postmark_template, :kafka_topic, :kafka_offset, presence: true
  validates :kafka_topic, uniqueness: {
    scope: :kafka_offset,
    message: 'and offset already exists'
  }
end
