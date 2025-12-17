FROM crystallang/crystal:1.18.2

LABEL maintainer="Vitalii Elenhaupt <velenhaupt@gmail.com>"
LABEL com.github.actions.name="Ameba checks"
LABEL com.github.actions.description="Lint your Crystal code in parallel to your builds"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="red"

ENV GITHUB_WORKSPACE=""

WORKDIR /app
COPY . /app

RUN shards install

ENTRYPOINT /app/bin/ameba --format github-actions "$GITHUB_WORKSPACE"
