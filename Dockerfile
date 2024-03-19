FROM debezium/website-builder

RUN apk add --update vips uglify-js && \
    mkdir -p /site && \
    git config --global --add safe.directory /site
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /site

CMD ["/usr/local/bin/entrypoint.sh"]

