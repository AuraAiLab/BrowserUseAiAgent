# Browser-Use AI Agent Installation Guide

This guide provides step-by-step instructions for deploying the browser-use AI agent in a Kubernetes environment using containerd.

## Prerequisites

- Kubernetes cluster with containerd runtime
- kubectl configured to access your cluster
- Access to a container registry (if using a private registry)
- OpenAI API key

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/AuraAiLab/BrowserUseAiAgent.git
cd BrowserUseAiAgent-Setup
```

### 2. Build the Container Image

Using containerd-compatible tools:

```bash
cd container
# If using nerdctl:
nerdctl build -t browser-use-agent:latest .

# If using buildah:
buildah bud -t browser-use-agent:latest .
```

### 3. Configure the Application

The default configuration uses OpenAI's GPT-4o model. You can modify the configuration by editing:

- `configs/kubernetes/configmap.yaml` - to change the task and model
- `app/main.py` - to customize the agent's behavior

### 4. Deploy to Kubernetes

The easiest way to deploy is using the provided script:

```bash
./scripts/deploy.sh
```

This will:
- Create the necessary namespace
- Prompt for your OpenAI API key
- Apply all Kubernetes configurations

Alternatively, you can apply each configuration individually:

```bash
kubectl apply -f configs/kubernetes/namespace.yaml
kubectl apply -f configs/kubernetes/configmap.yaml
kubectl apply -f configs/kubernetes/secret.yaml
kubectl apply -f configs/kubernetes/deployment.yaml
kubectl apply -f configs/kubernetes/service.yaml
```

### 5. Verify the Deployment

Check if the pods are running:

```bash
kubectl get pods -n ai-agents
```

View the logs of the browser-use agent:

```bash
kubectl logs -n ai-agents -l app=browser-use-agent
```

## Configuring for Mistral 7b on Ollama

To use Mistral 7b on Ollama instead of OpenAI:

1. Edit the `app/main.py` file to use the Ollama-hosted Mistral model:

```python
from langchain_community.llms import Ollama
from browser_use import Agent
import asyncio

async def main():
    agent = Agent(
        task="Your task here",
        llm=Ollama(model="mistral:7b"),
    )
    await agent.run()

asyncio.run(main())
```

2. Update the `container/Dockerfile` to install the required packages:

```
RUN pip install --no-cache-dir browser-use python-dotenv langchain-community
```

3. Update the Kubernetes configurations to point to your Ollama service.

## Troubleshooting

### Common Issues

1. **Pod fails to start**: Check the pod events and logs
   ```bash
   kubectl describe pod -n ai-agents -l app=browser-use-agent
   kubectl logs -n ai-agents -l app=browser-use-agent
   ```

2. **API key issues**: Verify the secret was created correctly
   ```bash
   kubectl get secret -n ai-agents ai-agent-secrets -o yaml
   ```

3. **Container image not found**: Ensure the image is available in your registry
   ```bash
   kubectl describe pod -n ai-agents -l app=browser-use-agent
   ```
