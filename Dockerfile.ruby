FROM debian:bookworm-slim
LABEL org.opencontainers.image.authors="Stefan Sundin"
LABEL org.opencontainers.image.url="https://github.com/stefansundin/dockerfiles"

ENV RUBY_VERSION=3.2.2
ENV DEBIAN_FRONTEND=noninteractive

# install gem dependencies
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    # useful system utilities when debugging:
    vim less \
    # ruby-build dependencies:
    ca-certificates curl gcc make bzip2 zlib1g-dev libyaml-dev \
    # yjit:
    rustc \
    # common gem dependencies:
    libreadline-dev libxml2-dev libxslt1-dev libpq-dev libsqlite3-dev libssl-dev libcurl4 xz-utils \
    # support git source in Gemfile:
    git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN rustc --version

# install ruby-build
RUN mkdir -p /usr/local/ruby-build
RUN curl -L https://github.com/rbenv/ruby-build/archive/master.tar.gz | tar xz --strip-components=1 -C /usr/local/ruby-build
ENV PATH=/usr/local/ruby-build/bin:$PATH

# skip gem documentation
RUN mkdir -p /usr/local/ruby/etc
RUN echo 'gem: --no-document' >> /usr/local/ruby/etc/gemrc

# install ruby
RUN \
  RUBY_CFLAGS=-s \
  ruby-build $RUBY_VERSION /usr/local/ruby

ENV PATH=/usr/local/ruby/bin:$PATH
RUN gem update --system

# silence "Don't run Bundler as root."
RUN bundle config --global silence_root_warning 1

# put the app in /app
CMD mkdir /app
WORKDIR /app

# you may want to override this in your Dockerfile
ENV APP_ENV=production
ENV RACK_ENV=deployment
ENV RAILS_ENV=production

# https://devcenter.heroku.com/articles/tuning-glibc-memory-behavior
ENV MALLOC_ARENA_MAX=2

ENV PATH=bin:$PATH
