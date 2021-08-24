###############################
### fetch all needed gems
###############################
FROM ruby:3.0.2-bullseye AS bundler

RUN apt-get update -y \
  && apt-get install -y \
  build-essential \
  libxml2-dev \
  libxslt-dev \
  && apt-get clean -y \
  && mkdir -p /bundler \
  && bundle config --global frozen 1

WORKDIR /bundler

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

ENV GEM_HOME="/bundler/vendor/bundle"

RUN GEM_HOME="/bundler/vendor/bundle" bundle install --without development test -j4 --retry 3 --path ./vendor/bundle \
  && rm -rf ./vendor/bundle/cache/*.gem \
  && ls -l /bundler/vendor/bundle/ruby/3.0.0/gems \
  && find ./vendor/bundle/ -type f  \( \
      -name "*.c" \
      -name "*.o" \
      -name "*.h" \
    \) -exec rm {} \;



###############################
### run the app
###############################
FROM ruby:3.0.2-bullseye AS runner

RUN mkdir -p /application/log && mkdir -p /application/storage
WORKDIR /application

COPY /config.ru /Rakefile /application/
COPY /bin /application/bin
COPY /public /application/public
COPY /config /application/config
COPY Gemfile Gemfile.lock /application/
COPY /db /application/db
COPY /lib /application/lib
COPY /app /application/app

COPY --from=bundler /bundler/vendor/bundle /application/vendor/bundle

RUN bundle install --without development test -j4 --retry 3 --path /application/vendor/bundle \
      && ls -l /application/vendor/bundle/ruby/3.0.0 \
      && rm -rf /application/vendor/bundle/ruby/3.0.0/cache/*.gem \
      && find /application/vendor/bundle/ruby/3.0.0/gems/ -type f  \( \
        -name "*.c" \
        -name "*.o" \
        -name "*.h" \
      \) -exec rm {} \;

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=1
ENV PATH="/application/bin:$PATH"

CMD ["rails", "s", "--early-hints"]
