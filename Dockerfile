FROM ruby:2.3.1-alpine

RUN apk update && apk add build-base nodejs mariadb-dev tzdata git libxml2-dev

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

# The ENV variables simply need to be set for Rails to correctly pre-compile
# your assets. They do not need to be populated by real values.
RUN bundle exec rake RAILS_ENV=production DATABASE_URL=mysql2://user:pass@127.0.0.1/dbname SECRET_TOKEN=dummytoken assets:precompile

CMD puma -C config/puma.rb
