ARG VECTORSCAN_IMG_TAG=latest
ARG VECTORSCAN_IMAGE_REPOSITORY=khulnasoft
FROM $VECTORSCAN_IMAGE_REPOSITORY/khulnasoft_vectorscan_build:$VECTORSCAN_IMG_TAG AS vectorscan

FROM golang:1.20-alpine3.18 AS builder
MAINTAINER KhulnaSoft

RUN apk update  \
    && apk add --upgrade gcc musl-dev pkgconfig g++ make git

COPY --from=vectorscan /vectorscan.tar.bz2 /
RUN tar -xjf /vectorscan.tar.bz2 -C / && rm /vectorscan.tar.bz2

WORKDIR /home/khulnasoft/src/SecretScanner
COPY . .
RUN make clean
RUN make

FROM alpine:3.19
MAINTAINER KhulnaSoft
LABEL khulnasoft.role=system

ENV MGMT_CONSOLE_URL=khulnasoft-internal-router \
    MGMT_CONSOLE_PORT=443

ARG TARGETARCH

RUN apk add --no-cache --upgrade tar libstdc++ libgcc docker skopeo bash podman

RUN <<EOF
set -eux

apk update && apk add --no-cache --upgrade curl 

NERDCTL_VERSION=1.4.0
curl -fsSLO https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${TARGETARCH}.tar.gz
tar Cxzvvf /usr/local/bin nerdctl-${NERDCTL_VERSION}-linux-${TARGETARCH}.tar.gz
rm nerdctl-${NERDCTL_VERSION}-linux-${TARGETARCH}.tar.gz

apk del curl
EOF

WORKDIR /home/khulnasoft/usr
COPY --from=builder /home/khulnasoft/src/SecretScanner/SecretScanner .
COPY --from=builder /home/khulnasoft/src/SecretScanner/config.yaml .
WORKDIR /home/khulnasoft/output

ENTRYPOINT ["/home/khulnasoft/usr/SecretScanner", "-config-path", "/home/khulnasoft/usr"]
CMD ["-h"]
