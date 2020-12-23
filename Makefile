BUILD_IMAGE ?= "kevinearls/simplehttp:latest"

.PHONY: build
build:
	go build -o simpleHTTP ./simpleHTTP.go

.PHONY: docker-build
docker-build: build
	docker build . --tag ${BUILD_IMAGE}

