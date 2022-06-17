# frozen_string_literal: true

FactoryBot.define do
  factory :email_notification do
    tenant { Faker::Company.name }
    organization_id { 1 }
    email { Faker::Internet.email }
    postmark_template { Faker::TvShows::RickAndMorty.character.underscore.downcase }
    status { 'created' }
    sequence(:kafka_offset)
    kafka_topic { Faker::TvShows::StrangerThings.character.underscore.downcase }
    args { { bar: 'bar', foo: 'foo' } }
  end
end
