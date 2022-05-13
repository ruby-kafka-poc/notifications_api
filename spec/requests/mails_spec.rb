# frozen_string_literal: true

require 'rails_helper'
require 'requests_helper'
require 'json'

RSpec.describe '/mails', type: :request do
  let(:attributes) do
    {
      to: Faker::Internet.email,
      code: Faker::Name.last_name,
      options: {
        foo: 'bar',
        fee: 'beer'
      }
    }
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new email' do
        post mail_url, params: attributes, as: :json
        expect(JSON.parse(response.body).with_indifferent_access).to match(message: 'sent')
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'without to' do
      let(:attributes) do
        {
          code: Faker::Name.last_name,
          options: {
            foo: 'bar',
            fee: 'beer'
          }
        }
      end

      it 'fails email' do
        post mail_url, params: attributes, as: :json
        expect(JSON.parse(response.body).with_indifferent_access).to match(error: '`to` is required')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'without code' do
      let(:attributes) do
        {
          to: Faker::Internet.email,
          options: {
            foo: 'bar',
            fee: 'beer'
          }
        }
      end

      it 'fails email' do
        post mail_url, params: attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body).with_indifferent_access).to match(error: '`code` is required')
      end
    end
  end
end
