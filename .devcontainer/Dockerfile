ARG VARIANT="2.7-bullseye"
FROM mcr.microsoft.com/devcontainers/ruby:${VARIANT}

USER root

# ENV Variables required by Jekyll
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TZ=Etc/UTC \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US

# Install bundler
RUN gem update --system
RUN gem install bundler

RUN chown -R "vscode:rvm" "/usr/local/rvm/" \
    && chmod -R g+r+w "/usr/local/rvm/" \
    && find "/usr/local/rvm/" -type d | xargs -n 1 chmod g+s

COPY post-create.sh /usr/local/post-create.sh
COPY build.sh /usr/local/build.sh

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} && nvm use ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libvips42 uglifyjs

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
