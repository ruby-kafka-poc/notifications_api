# README

This API act as a consumer for kafka. It expect events, and when it happens, it send an email using Postmark.

To configure events you need to add it:

notifications_api/karafka.rb:44

```ruby
topic 'topic_name' do
  consumer ConsumerClassName
end
```

and create the consumer 

notifications_api/app/consumers/ConsumerClassName.rb

```ruby
class CustomerCreatedConsumer < ApplicationConsumer
  def initialize
    super
    self.base_template = 'test-email1' # <-- This is the alias of the postmark template to use
  end
end
```

The Event need to provide an `email` attribute, otherwise will fail.

Lastly the API will save each mail sent, and the kafka topic+partition to avoid send it again. So if the service is down, we can start from a previous state without the risk of send it twice.
Also we can consult with a REST api the status of the email (Processed, Delivered, Opened, Failed)
