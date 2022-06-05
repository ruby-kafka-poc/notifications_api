# frozen_string_literal: true

require 'daemons'

namespace :kafka_consumers do
  desc 'Run the consumer services'

  task start: :environment do
    Consumers::Application.subclasses do |consumer|
      Daemons.call(multiple: true) do
        consumer.new
      end
    end
    end

  task stop: :environment do
    debugger
  end
end
