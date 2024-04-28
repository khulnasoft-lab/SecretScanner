all: SecretScanner

bootstrap:
	$(PWD)/bootstrap.sh

clean:
	-rm ./SecretScanner

SecretScanner: $(PWD)/**/*.go $(PWD)/agent-plugins-grpc/**/*.go
	go mod tidy -v
	go mod vendor
	go build -ldflags="-extldflags=-static" -buildvcs=false -v .

.PHONY: clean bootstrap

.PHONY: docker
docker:
	docker build -t docker.io/khulnasoft/khulnasoft_secret_scanner_ce:2.2.0 .
