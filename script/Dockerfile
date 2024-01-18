From ruby:3.2

RUN mkdir -p /opt/jekyll
WORKDIR /opt/jekyll

COPY Gemfile ./
RUN bundle config set path /opt/jekyll/vendor/bundle && \
    bundle install

WORKDIR /workspace
