FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install browser-use and its dependencies
RUN pip install --no-cache-dir browser-use python-dotenv langchain-openai

# Install Playwright and browsers
RUN pip install playwright
RUN playwright install chromium

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "main.py"]
