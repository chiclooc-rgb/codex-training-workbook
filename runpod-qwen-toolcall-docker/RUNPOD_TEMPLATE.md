# RunPod Template 입력값 초안

RunPod Custom Pod Template에 넣을 값이다.

## 기본

```text
Template Name:
  qwen-toolcall-vllm

Container Image:
  ghcr.io/chiclooc-rgb/qwen-toolcall-vllm:latest

Container Registry Credentials:
  package가 public이면 비움
  package가 private이면 GitHub 사용자명 + package read token 입력

Container Disk:
  80 GB 이상

Volume Disk:
  100 GB 이상 권장

Volume Mount Path:
  /workspace
```

## 포트

```text
Expose HTTP Ports:
  8000

Expose TCP Ports:
  필요 시 SSH 포트만 RunPod 기본값 사용
```

## 환경변수

```text
MODEL_ID=Qwen/Qwen3-Coder-30B-A3B-Instruct
MAX_MODEL_LEN=8192
GPU_MEMORY_UTILIZATION=0.90
TOOL_CALL_PARSER=qwen3_xml
REASONING_PARSER=qwen3
HF_HOME=/workspace/hf-cache
HUGGINGFACE_HUB_CACHE=/workspace/hf-cache
```

필요할 때만 추가:

```text
HF_TOKEN=<huggingface-token>
VLLM_EXTRA_ARGS=--trust-remote-code
```

## 추천 GPU

```text
Qwen 14B:
  16GB VRAM

Qwen 30B/32B:
  RTX 3090/4090 24GB

긴 컨텍스트:
  32GB 이상 VRAM
```

## 실행 확인

Pod 로그에서 다음을 확인한다.

```text
Starting vLLM OpenAI-compatible server
MODEL_ID=...
Uvicorn running on http://0.0.0.0:8000
```

RunPod 프록시 URL:

```text
https://<pod-id>-8000.proxy.runpod.net/v1
```
