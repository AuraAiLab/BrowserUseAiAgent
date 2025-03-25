#!/bin/bash
set -e

# Install browser-use agent locally on MacBook
echo "Setting up browser-use AI agent on MacBook..."

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install dependencies
echo "Installing required packages..."
pip install --upgrade pip
pip install langchain-openai browser-use gradio python-dotenv

# Install playwright browsers
echo "Installing playwright browsers..."
python -m playwright install

# Create .env file for API keys if it doesn't exist
if [ ! -f .env ]; then
  echo "Creating .env file for API keys..."
  echo "OPENAI_API_KEY=your-api-key-here" > .env
  echo "Please edit the .env file and add your OpenAI API key"
fi

# Create app directory and main script
echo "Creating application files..."
mkdir -p app

# Create the main application script
cat > app/main.py << 'EOL'
from langchain_openai import ChatOpenAI
from browser_use import Agent
import asyncio
import os
import logging
import gradio as gr
import threading
import time
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger("browser-use-agent")

# Store agent results
results = []

async def run_agent(task, model="gpt-4o"):
    # Get API key from environment
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        logger.error("OPENAI_API_KEY environment variable is not set")
        return "Error: API key not set. Please check your .env file."
    
    logger.info(f"Initializing browser-use agent with task: {task}")
    
    try:
        # Configure LLM with the OpenAI model
        llm = ChatOpenAI(
            openai_api_key=openai_api_key,
            model=model
        )
        
        # Initialize the browser-use agent
        agent = Agent(
            llm=llm,
            task=task
        )
        
        # Run the agent
        result = await agent.run()
        logger.info("Agent task completed successfully")
        results.append({"task": task, "result": str(result)})
        return f"Task completed: {task}\nResult: {result}"
    except Exception as e:
        error_msg = f"Error running agent: {str(e)}"
        logger.error(error_msg)
        return error_msg

def submit_task(task, model="gpt-4o"):
    return asyncio.run(run_agent(task, model))

def get_results():
    if not results:
        return "No tasks completed yet."
    output = ""
    for i, result in enumerate(results):
        output += f"Task {i+1}: {result['task']}\nResult: {result['result']}\n\n"
    return output

# Create Gradio interface
with gr.Blocks(title="Browser-Use AI Agent") as demo:
    gr.Markdown("# Browser-Use AI Agent Web Interface")
    gr.Markdown("Submit tasks for the AI agent to perform using a browser")
    
    with gr.Tab("Submit Task"):
        task_input = gr.Textbox(label="Task Description", placeholder="Compare the price of gpt-4o and DeepSeek-V3")
        model_input = gr.Dropdown(["gpt-4o", "gpt-3.5-turbo"], label="Model", value="gpt-4o")
        submit_btn = gr.Button("Submit Task")
        output = gr.Textbox(label="Output")
        submit_btn.click(fn=submit_task, inputs=[task_input, model_input], outputs=output)
    
    with gr.Tab("Results"):
        results_output = gr.Textbox(label="Previous Results")
        refresh_btn = gr.Button("Refresh Results")
        refresh_btn.click(fn=get_results, inputs=[], outputs=results_output)

# Start Gradio server
if __name__ == "__main__":
    print("Starting Browser-Use AI Agent server...")
    print("Make sure you've set your OPENAI_API_KEY in the .env file")
    demo.launch(share=False)
EOL

# Create README file
cat > README.md << 'EOL'
# Browser-Use AI Agent - Local Installation

This is a local setup for the browser-use AI agent that allows an AI to browse the web and perform tasks.

## Installation

1. Run the installation script:
   ```
   bash scripts/install-local-mac.sh
   ```

2. Edit the `.env` file to add your OpenAI API key:
   ```
   OPENAI_API_KEY=your-api-key-here
   ```

3. Activate the virtual environment:
   ```
   source venv/bin/activate
   ```

4. Run the application:
   ```
   python app/main.py
   ```

5. Open your browser and go to:
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
EOL

# Create run script
cat > run-agent.sh << 'EOL'
#!/bin/bash

# Activate virtual environment
source venv/bin/activate

# Run the browser-use agent
python app/main.py
EOL

# Make scripts executable
chmod +x run-agent.sh

echo "Installation complete!"
echo "Before running, make sure to edit the .env file and add your OpenAI API key"
echo "To run the agent, use: ./run-agent.sh"
echo "Then access the web interface at: http://localhost:7860"
