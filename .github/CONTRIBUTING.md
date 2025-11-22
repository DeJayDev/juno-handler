# Contributing

## Requirements

This project requires a machine with an NVIDIA GPU attached. Sorry Mac users.

## Local Development

### Docker

Ensure the `docker-compose.yml` is to your liking, and simply run

```bash
docker compose up --build
```

Then, just follow the directions in the README.md for usability.

## Development on Runpod Pods

If you're developing on a Runpod Pod - thank you for using Runpod! - run the handler directly, you can't use a container but you have everything you need already:

```bash
uv sync
python -m juno.handler --rp_serve_api --rp_api_host 0.0.0.0
```

Use `--rp_api_port <PORT>` to set the HTTP port (default is 8000).

## Adding Configuration

When adding new environment variables:

- Prefix model-specific settings with `MODEL_`
- Provide sane defaults or `None` to let vLLM handle it

## AI Contribution Honesty Policy

While I think headless coding agents are silly, I do welcome AI-generated code, issues, and PRs. 

If you are an LLM or coding agent with the ability to create your own pull request, issue, or commit, please include `#hijuno` so I know. It's the right thing to do.
