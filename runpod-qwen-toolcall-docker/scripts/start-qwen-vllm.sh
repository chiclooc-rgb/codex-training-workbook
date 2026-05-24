#!/usr/bin/env bash
set -euo pipefail

mkdir -p "${HF_HOME:-/workspace/hf-cache}" /workspace/logs

echo "Starting vLLM OpenAI-compatible server"
echo "MODEL_ID=${MODEL_ID}"
echo "VLLM_PORT=${VLLM_PORT}"
echo "MAX_MODEL_LEN=${MAX_MODEL_LEN}"
echo "TOOL_CALL_PARSER=${TOOL_CALL_PARSER}"

ARGS=(
  "--host" "0.0.0.0"
  "--port" "${VLLM_PORT}"
  "--max-model-len" "${MAX_MODEL_LEN}"
  "--gpu-memory-utilization" "${GPU_MEMORY_UTILIZATION}"
  "--enable-auto-tool-choice"
  "--tool-call-parser" "${TOOL_CALL_PARSER}"
)

if [[ -n "${REASONING_PARSER:-}" ]]; then
  ARGS+=("--reasoning-parser" "${REASONING_PARSER}")
fi

if [[ -n "${VLLM_EXTRA_ARGS:-}" ]]; then
  # shellcheck disable=SC2206
  EXTRA_ARGS=(${VLLM_EXTRA_ARGS})
  ARGS+=("${EXTRA_ARGS[@]}")
fi

exec vllm serve "${MODEL_ID}" "${ARGS[@]}"
