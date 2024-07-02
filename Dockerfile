
ARG ALPINE_VERSION=3.20

FROM alpine:${ALPINE_VERSION} AS base

FROM base AS hugo
WORKDIR /tmp/hugo
ARG TARGETARCH
ARG HUGO_VERSION=0.126.0
RUN wget -O "hugo.tar.gz" "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${TARGETARCH}.tar.gz"
RUN tar -xf "hugo.tar.gz" hugo -C /usr/bin

FROM base AS build
WORKDIR /src
RUN apk add --update libc6-compat libstdc++
COPY --from=hugo /usr/bin/hugo /bin/hugo
RUN --mount=type=bind,target=.,rw hugo -d /out

FROM scratch
COPY --from=build /out /
