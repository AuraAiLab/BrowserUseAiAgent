from langchain_openai import ChatOpenAI
from browser_use import Agent
import asyncio
import os
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger("browser-use-agent")

async def main():
    # Get API key from environment
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        logger.error("OPENAI_API_KEY environment variable is not set")
        return
    
    logger.info("Initializing browser-use agent")
    
    # Example task - this can be configured as needed
    task = os.getenv("AGENT_TASK", "Compare the price of gpt-4o and DeepSeek-V3")
    model = os.getenv("AGENT_MODEL", "gpt-4o")
    
    logger.info(f"Running task: {task} with model: {model}")
    
    try:
        agent = Agent(
            task=task,
            llm=ChatOpenAI(model=model),
        )
        await agent.run()
        logger.info("Agent task completed successfully")
    except Exception as e:
        logger.error(f"Error running agent: {str(e)}")

if __name__ == "__main__":
    logger.info("Starting browser-use agent application")
    asyncio.run(main())
