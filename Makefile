BINARY_NAME=ssm-sh
TARGET ?= darwin
DOCKER_REPO=itsdalmo/ssm-sh

default: test

run: test
	@echo "== Run =="
	go run main.go

build: test
	@echo "== Build =="
	go build -o $(BINARY_NAME) -v

test:
	@echo "== Test =="
	go fmt $$(go list ./... | grep -v /vendor/)
	go vet -v ./...
	go test -race -v ./...

clean:
	@echo "== Cleaning =="
	rm ssm-sh*

run-docker:
	@echo "== Docker run =="
	docker run --rm $(DOCKER_REPO):latest

build-docker:
	@echo "== Docker build =="
	docker build -t $(DOCKER_REPO):latest .

build-release:
	@echo "== Release build =="
	CGO_ENABLED=0 GOOS=$(TARGET) GOARCH=amd64 go build -o $(BINARY_NAME)-$(TARGET)-amd64 -v

.PHONY: default build test build-docker run-docker build-release