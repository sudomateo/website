FROM golang:1.24.0 AS builder

ARG TARGETARCH

# Install curl.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Hugo.
ENV HUGO_VERSION=0.144.2
RUN curl -L -o /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${TARGETARCH}.tar.gz && \
    tar -xvf /tmp/hugo.tar.gz -C /usr/local/bin hugo && \
    rm -rf /tmp/hugo.tar.gz

# Build the Hugo site.
WORKDIR /app
COPY . .
RUN hugo --destination public

FROM nginx:latest

COPY --from=builder /app/public /usr/share/nginx/html
