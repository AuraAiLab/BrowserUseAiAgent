# Browser-Use AI Agent Kubernetes Deployment

This repository contains configuration files and documentation for deploying the [browser-use AI agent](https://github.com/browser-use/browser-use) on a Kubernetes cluster using containerd.

## Project Overview

The browser-use AI agent enables AI models to control and interact with web browsers, allowing for autonomous navigation, interaction, and information extraction from websites. This implementation is designed to run within a Kubernetes environment and can be configured to use different AI models.

## Repository Structure

```
/
├── app/                  # Application code for the browser-use agent
├── configs/              # Configuration files
│   └── kubernetes/       # Kubernetes manifests
├── container/            # Container definition files
│   └── Dockerfile        # Container image definition
├── docs/                 # Documentation
└── scripts/              # Installation and utility scripts
```

## Deployment Instructions

### Prerequisites
- Kubernetes cluster with containerd runtime
- kubectl configured to access your cluster
- OpenAI API key (for default configuration)
- Python 3.11+ (for local testing)

### Deployment Steps
1. Create the namespace:
   ```
   kubectl apply -f configs/kubernetes/namespace.yaml
   ```

2. Configure the API key:
   ```
   # Update the OpenAI API key in the secret before applying
   kubectl apply -f configs/kubernetes/secret.yaml
   ```

3. Deploy the application:
   ```
   kubectl apply -f configs/kubernetes/configmap.yaml
   kubectl apply -f configs/kubernetes/deployment.yaml
   kubectl apply -f configs/kubernetes/service.yaml
   ```

4. Verify the deployment:
   ```
   kubectl get pods -n ai-agents
   ```

## Configuration Options

The default configuration uses OpenAI's GPT-4o model. Future updates will include options to use Mistral 7b on Ollama.

## Building the Container Image

For containerd-based clusters:

```bash
cd container
nerdctl build -t browser-use-agent:latest .
# or using containerd-compatible tools
```

## References

- [browser-use GitHub Repository](https://github.com/browser-use/browser-use)
- [AuraAiLab Kubernetes Setup](https://github.com/AuraAiLab/Ansible-K8-AiServer)
