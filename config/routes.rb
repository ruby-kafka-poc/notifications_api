# frozen_string_literal: true

Rails.application.routes.draw do
  resource :mail, only: :create
end
