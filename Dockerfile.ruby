# https://hub.docker.com/r/stefansundin/ruby/
# docker build --pull --no-cache --squash -f Dockerfile.ruby -t stefansundin/ruby:2.6 .
# docker push stefansundin/ruby:2.6
# docker run -it stefansundin/ruby:2.6 bash

FROM ubuntu:18.04
MAINTAINER stefansundin https://github.com/stefansundin/dockerfiles

ENV DEBIAN_FRONTEND=noninteractive

# install gem dependencies
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    # ruby-build dependencies:
    ca-certificates curl gcc make bzip2 \
    # common gem dependencies:
    libreadline-dev libxml2-dev libxslt1-dev libpq-dev libsqlite3-dev libssl-dev libcurl4 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# install ruby-build
RUN mkdir -p /usr/local/ruby-build
RUN curl -L https://github.com/rbenv/ruby-build/archive/master.tar.gz | tar xz --strip-components=1 -C /usr/local/ruby-build
ENV PATH=/usr/local/ruby-build/bin:$PATH

# we don't want gem documentation
RUN mkdir -p /usr/local/ruby/etc
RUN echo 'gem: --no-document' >> /usr/local/ruby/etc/gemrc

# install ruby
RUN \
  RUBY_CFLAGS=-s \
  ruby-build 2.6.4 /usr/local/ruby

ENV PATH=/usr/local/ruby/bin:$PATH
RUN gem update --system
RUN gem install --force bundler

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
