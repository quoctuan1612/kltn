FROM ruby:2.5.5
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client && npm install -g yarn
ENV TZ=Aisa/Ho_Chi_Minh LANG=C.UTF-8

RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.7.0/migrate.linux-amd64.tar.gz | tar xvz
RUN cp migrate.linux-amd64 /usr/local/bin/migrate

WORKDIR /usr/src/app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . /usr/src/app
