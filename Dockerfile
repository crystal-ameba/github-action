FROM crystallang/crystal:0.31.1

LABEL com.github.actions.name="Ameba checks"
LABEL com.github.actions.description="Lint your Crystal code in parallel to your builds"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="red"

LABEL maintainer="Vitalii Elenhaupt <velenhaupt@gmail.com>"

COPY src /action/src
ENTRYPOINT ["/action/src/entrypoint.sh"]
