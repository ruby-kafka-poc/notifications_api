FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /api
WORKDIR /api

COPY Gemfile Gemfile.lock ./

RUN bundle install
COPY . /api
