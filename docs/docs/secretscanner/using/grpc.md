---
title: Using over GRPC
---

# Using over GRPC

You can run a persistent SecretScanner service and issue requests for scans using GRPC.  You first need to build SecretScanner from source, to generate the necessary proto files.

:::info

### Help needed!

These instructions are out-of-date and need refreshed
:::

## Prerequisites

You will need the [grcpurl](https://github.com/fullstorydev/grpcurl) tool.


## Run the SecretScanner gRPC server

Start the SecretScanner gRPC server:

```bash
docker run -it --rm --name=khulnasoft-secretscanner \
	-v $(pwd):/home/khulnasoft/output \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /tmp/sock:/tmp/sock \
	docker.io/khulnasoft/khulnasoft_secret_scanner_ce:2.2.0 \
	-socket-path /tmp/sock/s.sock
```


## Scan a Container Image

```bash
# run this from the repo directory, or update the import-path

grpcurl -plaintext -import-path ./agent-plugins-grpc/proto -proto secret_scanner.proto \
    -d '{"image": {"name": "node:latest"}}' \
    -unix '/tmp/sock.sock' \
    secret_scanner.SecretScanner/FindSecretInfo
```

## Scan a Local Directory

```bash
# run this from the repo directory, or update the import-path

grpcurl -plaintext -import-path ./agent-plugins-grpc/proto -proto secret_scanner.proto \
	-d '{"path": "/tmp"}' \
	-unix '/tmp/sock.sock' \
	secret_scanner.SecretScanner/FindSecretInfo
```

