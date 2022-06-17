# frozen_string_literal: true

class CreateEmailNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :email_notifications do |t|
      t.string :tenant, null: false, default: 'default'
      t.integer :organization_id
      t.string :email, null: false
      t.string :postmark_template, null: false
      t.string :postmark_message_id
      t.string :error_description
      t.string :status, null: false
      t.integer :kafka_offset, null: false
      t.string :kafka_topic, null: false
      t.jsonb :args, :jsonb, null: false, default: '{}'

      t.timestamps
    end

    add_index :email_notifications, %i[kafka_offset kafka_topic], unique: true
  end
end
