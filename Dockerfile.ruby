# https://hub.docker.com/r/stefansundin/ruby/
# docker build --squash -f Dockerfile.ruby -t stefansundin/ruby:2.5.1 .
# docker push stefansundin/ruby:2.5.1
# docker run -i -t stefansundin/ruby:2.5.1 bash

FROM ubuntu:16.04
MAINTAINER stefansundin https://github.com/stefansundin/dockerfiles

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# RUN apt-get upgrade -y
# ruby-build dependencies
RUN apt-get install -y --no-install-recommends ca-certificates curl gcc make bzip2
# install some common gem dependencies
RUN apt-get install -y --no-install-recommends libreadline-dev libxml2-dev libxslt1-dev libpq-dev libsqlite3-dev libssl-dev libcurl3

# install ruby-build
RUN mkdir -p /usr/local/ruby-build
RUN curl -L https://github.com/rbenv/ruby-build/archive/master.tar.gz | tar xz --strip-components=1 -C /usr/local/ruby-build
ENV PATH=/usr/local/ruby-build/bin:$PATH

# we don't want gem documentation
RUN mkdir -p /usr/local/ruby/etc
RUN echo 'gem: --no-document' >> /usr/local/ruby/etc/gemrc

# install ruby
RUN RUBY_CFLAGS=-s ruby-build 2.5.1 /usr/local/ruby
ENV PATH=/usr/local/ruby/bin:$PATH
RUN gem update --system
# 2.5.1 requires you to "gem install bundler" again?!
RUN gem install bundler

# silence "Don't run Bundler as root."
RUN bundle config --global silence_root_warning 1

# put the app in /app
CMD mkdir /app
WORKDIR /app

# you may want to override this in your Dockerfile
ENV APP_ENV=production
ENV RACK_ENV=deployment
ENV RAILS_ENV=production

ENV PATH=bin:$PATH

RUN rm -rf /var/lib/apt/lists/*
