#!/bin/bash
docker build -t romucha/multi-client:latest -t romucha/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t romucha/multi-server:latest -t romucha/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t romucha/multi-worker:latest -t romucha/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push romucha/multi-client:latest
docker push romucha/multi-server:latest
docker push romucha/multi-worker:latest

docker push romucha/multi-client:$SHA
docker push romucha/multi-server:$SHA
docker push romucha/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=romucha/multi-server:$SHA
kubectl set image deployments/client-deployment server=romucha/multi-client:$SHA
kubectl set image deployments/worker-deployment server=romucha/worker-client:$SHA