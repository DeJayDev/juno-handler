# Juno Runpod Handler

A general-purpose vLLM handler for Runpod Serverless endpoints.


## Usage

Send requests with your messages:

```json
{
  "input": {
    "messages": [
      {"role": "user", "content": "What is Runpod?"}
    ]
  }
}
```

<details>
<summary>Optional Request Parameters</summary>

Customize generation with optional parameters:

| Parameter       | Type     | Description                                      |
| --------------- | -------- | ------------------------------------------------ |
| `temperature`   | float    | Sampling temperature (lower = focused, higher = creative) |
| `max_tokens`    | int      | Maximum tokens to generate                       |
| `top_p`         | float    | Nucleus sampling threshold                       |
| `tools`         | list     | Tool/function definitions (OpenAI format)        |

Example with parameters:

```json
{
  "input": {
    "messages": [{"role": "user", "content": "Write a poem"}],
    "temperature": 0.9,
    "max_tokens": 512,
    "top_p": 0.95
  }
}
```

</details>

**Response format (OpenAI-compatible):**

```json
{
  "id": "chatcmpl-abc123",
  "object": "chat.completion",
  "created": 1234567890,
  "model": "model-name",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "content": "Hello! How can I help you?"
    },
    "finish_reason": "stop"
  }],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 8,
    "total_tokens": 18
  }
}
```

**On Runpod:**

```bash
curl -X POST https://api.runpod.ai/v2/$ENDPOINT_ID/runsync \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $RUNPOD_API_KEY" \
  -d '{
    "input": {
      "messages": [{"role": "user", "content": "Say hello!"}]
    }
  }'
```

**Testing locally:**

```bash
curl -X POST http://localhost:8000/runsync \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "messages": [{"role": "user", "content": "Say hello!"}]
    }
  }'
```

**OpenAI-compatible (via Runpod proxy):**

```python
from openai import OpenAI

client = OpenAI(
    api_key="YOUR_RUNPOD_API_KEY",
    base_url=f"https://api.runpod.ai/v2/{ENDPOINT_ID}/openai/v1"
)

response = client.chat.completions.create(
    model="unused",  # Model is set via MODEL_NAME environment variable
    messages=[{"role": "user", "content": "Say hello!"}]
)
```

## Configuration

**Required:**
- `MODEL_NAME` - HuggingFace model identifier

**Model settings:**
- `MODEL_DTYPE` - Data type (`float16`, `bfloat16`, `auto`, etc.)
- `MODEL_QUANTIZATION` - Quantization method (`awq`, `gptq`, `fp8`)
- `MODEL_TRUST_REMOTE_CODE` - Allow custom model code (`true`, `1`, `yes` to enable)
- `MODEL_TOKENIZER` - Tokenizer mode (default: `auto`)
- `MODEL_CONFIG_FORMAT` - Config format (default: `auto`)
- `MODEL_LOAD_FORMAT` - Load format (default: `auto`)

**Limits:**
- `MODEL_MAX_LEN` - Maximum context length in tokens
- `MODEL_MAX_NUM_SEQS` - Maximum sequences per iteration

**Generation defaults:**
- `MODEL_TEMPERATURE` (default: 0.15)
- `MODEL_MAX_TOKENS` (default: 32768)
- `MODEL_TOP_P` (default: 0.95)

**Runtime:**
- `GPU_MEMORY_UTILIZATION` (default: 0.8)
- `DISTRIBUTED_EXECUTOR_BACKEND` - Execution backend (`ray`, `mp`, `uni`)

**(Optional) Cache persistence:**
- `TORCH_HOME` - PyTorch cache directory (e.g. `/runpod-volume/.cache/torch`)
- `HF_HOME` - HuggingFace cache directory (e.g. `/runpod-volume/.cache/huggingface`)

Setting these to a network volume path persists compiled extensions and model weights across worker restarts, reducing cold start times.

## Models

Any HuggingFace model supported by vLLM works. For larger models, use quantized versions (look for `-AWQ` or `-GPTQ` suffix).

GGUF models are **not** supported.

## Development

See [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md) for development instructions.

## License

MIT
