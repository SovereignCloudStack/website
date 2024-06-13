FROM jekyll/builder:stable

RUN apk add --update vips uglify-js musl
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
RUN gem install bundler -v 2.5.11  && \
       bundle config set force_ruby_platform true

USER jekyll
WORKDIR /srv
RUN  git config --global --add safe.directory /srv
CMD ["/usr/local/bin/entrypoint.sh"]

