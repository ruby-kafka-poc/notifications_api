# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_07_135151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_notifications", force: :cascade do |t|
    t.string "tenant", default: "default", null: false
    t.integer "organization_id"
    t.string "email", null: false
    t.string "postmark_template", null: false
    t.string "status", null: false
    t.integer "kafka_partition", null: false
    t.string "kafka_topic", null: false
    t.jsonb "args", default: "{}", null: false
    t.jsonb "jsonb", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kafka_partition", "kafka_topic"], name: "index_email_notifications_on_kafka_partition_and_kafka_topic", unique: true
  end

end
