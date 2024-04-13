#! /bin/sh
# This script installs all prerequisites for editor service deployment pipeline
# Pre-requisites
# - aws secrets in kubernetes
# - kaniko secret for docker push


SERIVCENAME=appkube-editor
NAMESPACE=appkube-editor-service

echo Name of the Service: ${SERIVCENAME}
echo Namespace: ${NAMESPACE}

if kubectl -n ${NAMESPACE} get task git-clone ; then
    echo git-clone task exists
else    
    echo exit.., required task git-clone not present
    exit 1
fi

if kubectl -n ${NAMESPACE} get task build-kaniko ; then
    echo build-kaniko task exists
else    
    echo exit.., required task build-kaniko not present
    exit 1
fi

if kubectl -n ${NAMESPACE} get secrets smoke-aws-credentials ; then
    echo aws secret exists
else    
    echo exit.., required aws secret not present
    exit 1
fi

if kubectl -n ${NAMESPACE} get secrets kaniko-secret ; then
    echo kaniko secret exists
else    
    echo exit.., required kaniko secret not present
    exit 1
fi

# echo Add appkueb-editor specific tasks
kubectl apply -f tasks/build-appkube-editor-task.yaml
kubectl apply -f tasks/editor-helm-install.yaml
kubectl apply -f task/editor-helm-unstall.yaml

if kubectl get ns ${NAMESPACE} ; then
    echo ${NAMESPACE} namespace exists
else
    echo Creating ${NAMESPACE} and lable istio-injection: enabled
    kubectl apply -f helm/appkube-editor/editor-namespace.yaml
fi

echo Add the pipeline
kubectl apply -f pipelinerun/deploy-editor-service.yaml