# frozen_string_literal: true

require 'postmark_client'
require 'postmark_error'

class MailsController < ApplicationController
  # POST /mails
  def create
    PostmarkClient.new.deliver(create_params[:code], create_params[:to], create_params[:options])

    render json: { message: 'sent' }, status: :created
  rescue PostmarkError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def create_params
    params.permit(:code, :to, options: {})
  end
end
