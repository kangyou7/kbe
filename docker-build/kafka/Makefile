VERSION=0.10.2.0
PROJECT_ID=infra
PROJECT=registry.secuiot/${PROJECT_ID}

all: build

build:
	docker build --pull -t ${PROJECT}/kubernetes-kafka:${VERSION} .

push: build
	gcloud docker -- push ${PROJECT}/k8skafka:${VERSION}

.PHONY: all build push
