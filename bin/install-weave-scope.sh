#!/bin/bash


# Install Weave Scope
kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Create Weave Scope LoadBalancer
kubectl expose deploy weave-scope-app \
	--namespace=weave \
	--type=LoadBalancer \
	--name=weave-scope \
	--port=4040 \
	--target-port=4040 \
	--protocol=TCP \
	--external-ip=10.250.238.35
