# syntax=docker/dockerfile:1.7-labs
FROM python:3.12-slim AS base

# Prevent Python from writing .pyc and buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Create non-root user
RUN useradd -m appuser

# Set workdir
WORKDIR /app

# Install system deps (if you need build tools, add: build-essential, gcc, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install Python deps
RUN python -m pip install --upgrade pip && \
    pip install -r requirements.txt

WORKDIR /app
# Copy app source
COPY . ./app

# Expose port (for documentation)
EXPOSE 8000

# Set runtime env
ENV PORT=8000 \
    MESSAGE="Hello from Docker!"

# Use non-root user
USER appuser

# Start with Gunicorn (prod server)
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app.main:app"]
