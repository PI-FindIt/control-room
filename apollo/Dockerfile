FROM debian:bookworm-slim

RUN apt update && \
  apt install -y \
  curl \
  iputils-ping \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl -SL https://rover.apollo.dev/nix/latest | sh

ENV PATH="/root/.rover/bin:${PATH}"
RUN rover install --plugin supergraph@latest-2 --elv2-license accept --insecure-accept-invalid-hostnames --insecure-accept-invalid-certs --client-timeout 1000

CMD ["/bin/sh"]
