# Use specific version of nvidia cuda image
FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# Labeling for GHCR, then we'll build the image :)
LABEL org.opencontainers.image.source=https://github.com/dejaydev/juno-handler
LABEL org.opencontainers.image.description="The Juno Runpod handler, my ideal vLLM worker and Dockerfile for building a beautiful image."
LABEL org.opencontainers.image.licenses=MIT
# This is the location of the network volume for serverless endpoints.
ENV RP_WORKSPACE=/runpod-volume

# NOTICE: This variable will cause uv sync to uninstall system dependencies that are not in the pyproject.toml file.
# This includes Jupyter, which is installed by default in the base image. 
# You can avoid this by unsetting UV_PROJECT_ENVIRONMENT to use a venv or switching to pip to manage system packages.
ENV UV_PROJECT_ENVIRONMENT=/usr/local

# Pick a folder, call it whatever you want - we call this project Juno.
WORKDIR /opt/juno

COPY pyproject.toml uv.lock ./

RUN uv sync --no-dev

COPY juno ./juno
CMD ["python", "-m", "juno.handler", "--rp_serve_api", "--rp_api_host", "0.0.0.0"]
