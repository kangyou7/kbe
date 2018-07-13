VERSION=v3.4.10
#PROJECT_ID=google_samples
#PROJECT=gcr.io/${PROJECT_ID}
PROJECT_ID=infra
PROJECT=registry.secuiot/${PROJECT_ID}
APPNAME=zookeeper

all: build

build:
	docker build -t ${PROJECT}/${APPNAME}:${VERSION} .

push: build
	gcloud docker -- push ${PROJECT}/${APPNAME}:${VERSION}

.PHONY: all build push
