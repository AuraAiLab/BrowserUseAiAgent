#!/bin/bash

# Script to deploy browser-use AI agent to Kubernetes
# Assumes kubectl is configured correctly

set -e

echo "Deploying Browser-Use AI Agent to Kubernetes..."

# Set variables
NAMESPACE="ai-agents"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
KUBE_DIR="${SCRIPT_DIR}/../configs/kubernetes"

# Create namespace if it doesn't exist
echo "Creating namespace ${NAMESPACE} if it doesn't exist..."
kubectl apply -f "${KUBE_DIR}/namespace.yaml"

# Apply the configmap
echo "Applying ConfigMap..."
kubectl apply -f "${KUBE_DIR}/configmap.yaml"

# Check if secret exists, prompt for API key if needed
if ! kubectl get secret ai-agent-secrets -n "${NAMESPACE}" &>/dev/null; then
    echo "Secret 'ai-agent-secrets' not found. Creating it..."
    
    # Prompt for API key
    read -p "Enter your OpenAI API key: " API_KEY
    
    # Base64 encode the API key
    ENCODED_API_KEY=$(echo -n "${API_KEY}" | base64)
    
    # Create a temporary secret file
    TMP_SECRET_FILE=$(mktemp)
    cat "${KUBE_DIR}/secret.yaml" | sed "s/UkVQTEFDRV9XSVRIX1lPVVJfQVBJX0tFWQ==/${ENCODED_API_KEY}/" > "${TMP_SECRET_FILE}"
    
    # Apply the secret
    kubectl apply -f "${TMP_SECRET_FILE}"
    
    # Clean up
    rm "${TMP_SECRET_FILE}"
else
    echo "Secret 'ai-agent-secrets' already exists. Skipping creation."
fi

# Apply the deployment
echo "Applying Deployment..."
kubectl apply -f "${KUBE_DIR}/deployment.yaml"

# Apply the service
echo "Applying Service..."
kubectl apply -f "${KUBE_DIR}/service.yaml"

echo "Deployment complete! Use the following command to check status:"
echo "kubectl get pods -n ${NAMESPACE} -l app=browser-use-agent"
