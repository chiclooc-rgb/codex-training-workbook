from __future__ import annotations

import os
from openai import OpenAI


BASE_URL = os.environ.get("OPENAI_BASE_URL", "http://localhost:8000/v1")
MODEL_ID = os.environ.get("MODEL_ID", "Qwen/Qwen3-Coder-30B-A3B-Instruct")


def main() -> None:
    client = OpenAI(base_url=BASE_URL, api_key=os.environ.get("OPENAI_API_KEY", "EMPTY"))

    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_weather",
                "description": "도시의 날씨를 조회한다.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "city": {
                            "type": "string",
                            "description": "날씨를 조회할 도시명",
                        }
                    },
                    "required": ["city"],
                    "additionalProperties": False,
                },
            },
        }
    ]

    response = client.chat.completions.create(
        model=MODEL_ID,
        messages=[
            {
                "role": "user",
                "content": "서울 날씨를 확인해서 우산이 필요한지 알려줘.",
            }
        ],
        tools=tools,
        tool_choice="auto",
        temperature=0,
    )

    message = response.choices[0].message
    print("tool_calls:")
    print(message.tool_calls)
    print("\ncontent:")
    print(message.content)


if __name__ == "__main__":
    main()
