#!/bin/bash

if ! snapctl is-connected k8s-credentials; then
    >&2 echo "ERROR: Please make sure microk8s is installed, run \`snap connect $SNAP_INSTANCE_NAME:k8s-credentials microk8s:microk8s\`, and try again"
    exit 1
fi

export KUBECONFIG=$SNAP/microk8s/credentials/client.config

kubectl apply -f $SNAP/deploy/istio-namespace.yaml

istioctl manifest apply -f $SNAP/deploy/istio-minimal-operator.yaml -y

kubectl apply -f $SNAP/deploy/kserve.yaml
kubectl wait --for=condition=ready pod -l control-plane=kserve-controller-manager -n kserve --timeout=300s

kubectl apply -f $SNAP/deploy/mlflow-new.yaml
