FROM ghcr.io/crystal-ameba/ameba:master

LABEL maintainer="Vitalii Elenhaupt <velenhaupt@gmail.com>"
LABEL com.github.actions.name="Ameba checks"
LABEL com.github.actions.description="Lint your Crystal code in parallel to your builds"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="red"

ENV GITHUB_WORKSPACE=""

ENTRYPOINT /usr/bin/ameba --format github-actions "$GITHUB_WORKSPACE"
