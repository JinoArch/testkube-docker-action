FROM alpine:latest

USER root

ENV PLATFORM="Linux_x86_64"

# Install curl to download testkube
RUN apk update && apk --no-cache add curl jq && \
    # Install aws-cli
    apk add --no-cache aws-cli

# Configure testkube
RUN mkdir .testkube && echo "{}" > .testkube/config.json

# Clean installation
RUN rm -rf LICENSE README.md && apk del curl jq

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
