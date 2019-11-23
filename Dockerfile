FROM crystallang/crystal:0.31.1 as builder
WORKDIR /tmp/build
COPY . /tmp/build
RUN shards build --production

FROM ubuntu:16.04
LABEL com.github.actions.name="Ameba checks"
LABEL com.github.actions.description="Lint your Crystal code in parallel to your builds"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="red"

LABEL maintainer="Vitalii Elenhaupt <velenhaupt@gmail.com>"

FROM ubuntu:16.04
RUN apt-get update && apt-get -y install libyaml-dev libevent-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /tmp/build/bin/ameba-github_action /opt/app/
# Configure user
RUN adduser --disabled-password --gecos "" docker
RUN ["chown", "-R", "docker:docker", "/opt/app"]
USER docker

ENTRYPOINT ["/opt/app/ameba-github_action"]
