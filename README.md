# Browser-Use AI Agent - MacOS Installation

This repository contains installation scripts and documentation for setting up the [browser-use AI agent](https://github.com/browser-use/browser-use) on macOS 14.6.1 (Sonoma).

## Project Overview

The browser-use AI agent enables AI models to control and interact with web browsers, allowing for autonomous navigation, interaction, and information extraction from websites. This implementation is designed to run on macOS systems and can be configured to use different AI models.

## Repository Structure

```
/
├── app/                  # Application code for the browser-use agent
├── configs/              # Configuration files (legacy Kubernetes configs also included)
├── docs/                 # Documentation
└── scripts/              # Installation and utility scripts
    └── install-local-mac.sh   # MacOS installation script
```

## Installation Instructions

### Prerequisites
- macOS 14.6.1 (Sonoma) or compatible version
- Python 3.11+
- OpenAI API key (for default configuration)

### Installation Steps

1. Clone this repository:
   ```
   git clone https://github.com/AuraAiLab/BrowserUseAiAgent.git
   cd BrowserUseAiAgent
   ```

2. Run the installation script:
   ```
   ./scripts/install-local-mac.sh
   ```

3. Edit the `.env` file to add your OpenAI API key:
   ```
   OPENAI_API_KEY=your-api-key-here
   ```

4. Run the application:
   ```
   ./run-agent.sh
   ```

5. Access the web interface at:
   ```
   http://localhost:7860
   ```

## Usage

1. Enter a task for the AI agent in the "Task Description" field.
2. Select the model you want to use (gpt-4o or gpt-3.5-turbo).
3. Click "Submit Task" to start the agent.
4. View the results in the "Results" tab.

## Troubleshooting

If you encounter any issues:
- Make sure your OpenAI API key is correctly set in the `.env` file
- Check that you have an active internet connection
- Ensure that the virtual environment is activated

## Future Plans

Future versions will support integration with:
- Mistral 7b on Ollama for local LLM capabilities
- Additional browser automation options

## Legacy Kubernetes Configuration

This repository also contains Kubernetes configuration files in the `configs/kubernetes/` directory, which were used in earlier versions of this project. These are kept for reference but are no longer the primary deployment method.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
