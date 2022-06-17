# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostmarkClient, type: :lib do
  context '#deliver' do
    context 'invalid' do
      it 'fail without to' do
        expect { PostmarkClient.new.deliver('abc', '') }.to raise_error(PostmarkError)
      end

      it 'fail with invalid email to' do
        expect { PostmarkClient.new.deliver('abc', 'asd') }.to raise_error(PostmarkError)
        expect { PostmarkClient.new.deliver('abc', 'asd@') }.to raise_error(PostmarkError)
        expect { PostmarkClient.new.deliver('abc', 'asd#asd') }.to raise_error(PostmarkError)
      end

      it 'fail without code' do
        expect { PostmarkClient.new.deliver('', 'asd@asd.com') }.to raise_error(PostmarkError)
      end

      it 'return an error' do
        expect_any_instance_of(Postmark::ApiClient).to receive(:deliver_with_template).and_raise(
          Postmark::ApiInputError
        )
        expect(PostmarkClient.new.deliver(
          'a',
          'asd@asd.com'
        ).message).to eq('The Postmark API responded with HTTP status 422.')
      end

      it 'return an error' do
        expect_any_instance_of(Postmark::ApiClient).to receive(:deliver_with_template).and_raise(
          Postmark::InactiveRecipientError
        )
        expect(PostmarkClient.new.deliver(
          'a',
          'asd@asd.com'
        ).message).to eq('The Postmark API responded with HTTP status 422.')
      end
    end

    context 'valid' do
      before do
        expect_any_instance_of(Postmark::ApiClient).to receive(:deliver_with_template).once
      end

      it 'send' do
        PostmarkClient.new.deliver('abc', 'asd@asd.com')
      end
    end
  end

  context '#templates' do
    before do
      expect_any_instance_of(Postmark::ApiClient).to receive(:get_templates).and_return(
        [
          3,
          [
            { a: 'a', alias: 'default-an_alias' },
            { b: 'b', alias: 'default-an_organization-an_alias' },
            { b: 'b', alias: 'a_tenant-an_organization-an_alias' },
            { c: 'c', alias: 'a_tenant-alias' }
          ]
        ]
      )
    end

    it 'use default tenant' do
      expect(PostmarkClient.new.templates('an_alias', nil)).to eq(%w[default-an_alias])
    end

    it 'use the organization' do
      expect(
        PostmarkClient.new.templates('an_alias', 'an_organization')
      ).to eq(%w[default-an_alias default-an_organization-an_alias])
    end
  end
end
