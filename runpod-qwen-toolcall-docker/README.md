# RunPod Qwen Tool Calling Docker

RunPod에서 Qwen 계열 로컬 모델의 툴콜을 검증하기 위한 커스텀 Docker 이미지 초안이다.

목표는 다음과 같다.

- RunPod Pod를 만들 때 매번 vLLM 설치를 반복하지 않는다.
- 컨테이너 시작과 동시에 Qwen vLLM OpenAI 호환 서버를 띄운다.
- `/workspace/hf-cache`를 볼륨으로 잡아 모델 재다운로드를 줄인다.
- 8000번 포트로 OpenAI 호환 API를 열고 `tool_calls`가 실제로 잡히는지 확인한다.

## 1. 이미지 구조

```text
Dockerfile
scripts/start-qwen-vllm.sh
examples/test_toolcall.py
```

기본 베이스 이미지는 공식 vLLM OpenAI 서버 이미지다.

```dockerfile
FROM vllm/vllm-openai:latest
```

vLLM 공식 문서는 이 이미지를 OpenAI 호환 서버 실행용으로 제공하며, `-p 8000:8000`, Hugging Face 캐시 볼륨, `HF_TOKEN` 환경변수 조합을 예시로 든다.

## 2. 로컬에서 이미지 빌드

Docker가 설치된 PC에서 실행한다.

```bash
docker build -t qwen-toolcall-vllm:0.1 .
```

로컬 PC에 NVIDIA GPU와 Docker GPU 런타임이 있으면 테스트 실행도 가능하다.

```bash
docker run --gpus all --ipc=host \
  -p 8000:8000 \
  -v "%USERPROFILE%/.cache/huggingface:/workspace/hf-cache" \
  -e MODEL_ID="Qwen/Qwen3-Coder-30B-A3B-Instruct" \
  qwen-toolcall-vllm:0.1
```

Windows PowerShell에서 경로 문제가 나면 절대경로로 바꾼다.

## 3. GitHub Actions로 GHCR 이미지 만들기

이 저장소에는 GitHub Actions 워크플로가 들어 있다.

```text
.github/workflows/build-runpod-qwen-toolcall-image.yml
```

`runpod-qwen-toolcall-docker/` 폴더가 바뀌거나 수동 실행하면 GHCR 이미지가 만들어진다.

```text
ghcr.io/chiclooc-rgb/qwen-toolcall-vllm:latest
```

커밋 SHA 태그도 함께 만들어진다.

```text
ghcr.io/chiclooc-rgb/qwen-toolcall-vllm:main-<sha>
```

레포가 private이면 GHCR 패키지도 private으로 잡힐 수 있다. 이 경우 RunPod 템플릿에서 registry credentials에 GitHub 사용자명과 package read 권한이 있는 token을 넣거나, GitHub Packages 화면에서 패키지를 public으로 바꾼다.

## 4. 직접 Docker Hub 또는 GHCR에 푸시

예시는 Docker Hub 기준이다.

```bash
docker tag qwen-toolcall-vllm:0.1 <dockerhub-id>/qwen-toolcall-vllm:0.1
docker push <dockerhub-id>/qwen-toolcall-vllm:0.1
```

GitHub Container Registry를 쓰면 이미지명은 보통 다음처럼 된다.

```bash
ghcr.io/<github-id>/qwen-toolcall-vllm:0.1
```

RunPod 템플릿에는 이 이미지 주소를 넣는다.

## 5. RunPod 템플릿 설정

RunPod에서 Custom Pod Template을 만들 때 다음처럼 설정한다.

```text
Container Image:
  ghcr.io/chiclooc-rgb/qwen-toolcall-vllm:latest

Container Disk:
  80GB 이상 권장

Volume Mount Path:
  /workspace

Expose HTTP Ports:
  8000

Environment Variables:
  MODEL_ID=Qwen/Qwen3-Coder-30B-A3B-Instruct
  MAX_MODEL_LEN=8192
  GPU_MEMORY_UTILIZATION=0.90
  TOOL_CALL_PARSER=qwen3_xml
  REASONING_PARSER=qwen3
  HF_TOKEN=<필요할 때만>
```

Qwen 모델이 공개 모델이면 `HF_TOKEN` 없이도 받을 수 있다. gated 모델이나 다운로드 제한이 있으면 Hugging Face 토큰을 넣는다.

## 6. Pod 실행 후 확인

RunPod가 8000번 포트를 프록시로 열면 보통 다음과 비슷한 주소가 생긴다.

```text
https://<pod-id>-8000.proxy.runpod.net/v1
```

내 PC에서 테스트한다.

```bash
set OPENAI_BASE_URL=https://<pod-id>-8000.proxy.runpod.net/v1
set MODEL_ID=Qwen/Qwen3-Coder-30B-A3B-Instruct
python examples/test_toolcall.py
```

PowerShell에서는 다음처럼 쓴다.

```powershell
$env:OPENAI_BASE_URL="https://<pod-id>-8000.proxy.runpod.net/v1"
$env:MODEL_ID="Qwen/Qwen3-Coder-30B-A3B-Instruct"
python examples/test_toolcall.py
```

성공 기준:

- `tool_calls`에 `get_weather`가 들어간다.
- 인자에 `city`가 들어간다.
- `content`에 툴콜 JSON만 덩그러니 찍히지 않는다.

## 7. 파서가 안 맞을 때

증상:

- `tool_calls`가 `None`이다.
- `content`에 `<tool_call>`이나 JSON이 그대로 찍힌다.
- 몇 턴 지나면 툴콜 형식이 무너진다.

우선 바꿔볼 환경변수:

```text
TOOL_CALL_PARSER=qwen3_xml
TOOL_CALL_PARSER=qwen3_coder
TOOL_CALL_PARSER=hermes
```

모델 종류와 vLLM 버전에 따라 맞는 파서가 달라질 수 있다. Qwen3 계열은 vLLM 문서 기준 `qwen3_xml` 플래그가 있고, 일부 사용자 경험에서는 `qwen3_coder`나 `hermes`가 더 나은 조합으로 보고되기도 했다.

## 8. 테스트가 끝나면

RunPod Pod는 켜져 있으면 과금된다.

```text
짧은 실험: Stop
완전 종료: Terminate/Delete
모델 캐시 유지: Network Volume 사용
```

모델 파일은 `/workspace/hf-cache`에 저장되도록 잡아두었다. RunPod Network Volume을 `/workspace`에 붙이면 다음 Pod에서도 재사용할 수 있다.
