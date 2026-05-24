FROM vllm/vllm-openai:latest

ENV HF_HOME=/workspace/hf-cache
ENV HUGGINGFACE_HUB_CACHE=/workspace/hf-cache
ENV VLLM_PORT=8000
ENV MODEL_ID=Qwen/Qwen3-Coder-30B-A3B-Instruct
ENV MAX_MODEL_LEN=8192
ENV GPU_MEMORY_UTILIZATION=0.90
ENV TOOL_CALL_PARSER=qwen3_xml
ENV REASONING_PARSER=qwen3

WORKDIR /workspace

RUN mkdir -p /workspace/hf-cache /workspace/logs /app

COPY scripts/start-qwen-vllm.sh /app/start-qwen-vllm.sh
COPY examples/test_toolcall.py /app/test_toolcall.py

RUN chmod +x /app/start-qwen-vllm.sh

EXPOSE 8000

ENTRYPOINT ["/app/start-qwen-vllm.sh"]
