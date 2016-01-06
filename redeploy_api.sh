#!/bin/bash

kubectl delete svc api-test
kubectl delete po test-api

kubectl create -f testpod.json
kubectl create -f  podservice.json
