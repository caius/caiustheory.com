FROM alpine:3.8

LABEL maintainer="Caius <dev@caius.name>"
LABEL com.github.actions.name="Postprocess CaiusTheory content"
LABEL com.github.actions.description="Postprocess CaiusTheory content after building"
LABEL com.github.actions.icon="sidebar"
LABEL com.github.actions.color="green"

# https://github.com/docker-library/docs/pull/689
ENV LANG C.UTF-8

RUN apk add make

CMD ["make", "postprocess"]
