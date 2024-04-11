#!/bin/bash

export KUBECONFIG=$SNAP/microk8s/credentials/client.config

kubectl apply -f $SNAP/deploy/istio-namespace.yaml

istioctl manifest apply -f $SNAP/deploy/istio-minimal-operator.yaml -y

kubectl apply -f $SNAP/deploy/kserve.yaml
kubectl wait --for=condition=ready pod -l control-plane=kserve-controller-manager -n kserve --timeout=300s

kubectl apply -f $SNAP/deploy/mlflow-new.yaml
