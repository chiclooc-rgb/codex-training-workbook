# DESIGN.md 스터디 Q&A 정리

작성일: 2026-05-24

## 1. 한 줄 정의

`DESIGN.md`는 AI 에이전트가 디자인을 매번 감으로 추측하지 않도록, 색상·타이포그래피·간격·컴포넌트 규칙과 그 의도를 한 파일에 적어두는 디자인 시스템 문서다.

Google Labs가 공개한 공식 설명에 따르면 `DESIGN.md`는 프로젝트 간 디자인 규칙을 export/import해서 재사용하기 위한 형식이며, AI 에이전트가 색상의 용도나 접근성 규칙을 추측하지 않고 읽을 수 있게 하는 것이 핵심이다.

## 2. 공식 DESIGN.md는 어떻게 생겼나

공식 스펙 기준으로는 두 층으로 구성된다.

1. YAML front matter
   - 기계가 읽는 값
   - 색상, 폰트, 간격, 둥근 정도, 컴포넌트 토큰

2. Markdown body
   - 사람이 읽는 설명
   - 왜 이 색을 쓰는지, 어떤 분위기인지, 어떤 경우에 쓰면 안 되는지

예시는 이런 형태다.

```markdown
---
name: Heritage
colors:
  primary: "#1A1C1E"
  secondary: "#6C7278"
  tertiary: "#B8422E"
typography:
  h1:
    fontFamily: Public Sans
    fontSize: 3rem
rounded:
  sm: 4px
spacing:
  sm: 8px
components:
  button-primary:
    backgroundColor: "{colors.tertiary}"
    textColor: "#FFFFFF"
---

## Overview
Architectural Minimalism meets Journalistic Gravitas.

## Colors
The palette is rooted in high-contrast neutrals and a single accent color.
```

핵심은 값만 적는 것이 아니라, "이 색은 어떤 역할인지", "이 폰트는 어떤 톤인지", "어떤 사용을 피해야 하는지"까지 같이 적는 것이다.

## 3. 꼭 파일명이 DESIGN.md여야 하나

공식 형식의 이름은 `DESIGN.md`다. 프로젝트 루트에 `DESIGN.md`를 두면 여러 에이전트와 도구가 기본 디자인 문서로 인식하기 쉽다.

하지만 실제 작업에서는 반드시 그 이름만 써야 하는 것은 아니다.

- `DESIGN.md`: 현재 프로젝트에서 활성화된 기본 디자인
- `DESIGN.training-ppt.md`: 교육 PPT용 스타일
- `DESIGN.report.md`: 보고서형 스타일
- `DESIGN.dark.md`: 다크 테마
- `designs/교육PT_A2Z.md`: 보관용 스타일 라이브러리

중요한 것은 파일명보다 "에이전트에게 어떤 파일을 기준으로 삼으라고 명확히 말하는 것"이다.

예:

```text
`designs/교육PT_A2Z.md`를 디자인 기준으로 삼아서
새 PPTX를 만들어줘.
```

다만 자동 탐색과 협업 안정성을 생각하면 현재 활성 스타일은 루트에 `DESIGN.md`로 두는 편이 가장 안전하다.

## 4. DESIGN.md 하나는 한 템플릿에만 쓰나

정확히 말하면 `DESIGN.md` 하나는 "한 개의 디자인 시스템"에 대응한다고 보는 것이 좋다.

여기서 디자인 시스템은 단일 슬라이드 템플릿 하나가 아니라, 같은 브랜드/같은 톤 안에서 함께 쓰이는 규칙 묶음이다.

한 파일 안에 넣어도 되는 것:

- 같은 교육자료 안의 표지, 도비라, 본문, 요약 슬라이드
- 같은 브랜드 안의 버튼 기본/호버/비활성 상태
- 같은 스타일 안의 라이트/다크 변형
- 같은 문서군 안의 보고서형/표형/카드형 레이아웃

파일을 나누는 것이 좋은 경우:

- 교육 PPT와 정책 보고서처럼 분위기가 완전히 다를 때
- 행사 홍보물과 내부 매뉴얼처럼 목적이 다를 때
- 색상, 폰트, 여백, 문체가 서로 충돌할 때
- 에이전트가 한 파일 안의 여러 스타일을 섞어버릴 위험이 있을 때

스터디에서 답변하면 이렇게 말하면 된다.

> 한 파일이 꼭 슬라이드 한 장짜리 템플릿만 의미하는 것은 아닙니다.  
> 같은 디자인 언어 안의 여러 화면/슬라이드 유형은 한 `DESIGN.md`에 넣어도 됩니다.  
> 다만 톤이 다른 디자인은 파일을 나누는 게 좋습니다. 그래야 에이전트가 스타일을 섞지 않습니다.

## 5. 우리 PPTX 실습의 design.md는 공식 스펙과 같은가

완전히 같지는 않다.

공식 `DESIGN.md`는 웹 UI와 코딩 에이전트가 읽기 좋은 디자인 시스템 형식이다. 색상, 타이포그래피, spacing, rounded, components 같은 토큰을 강조한다.

우리 교육 PPTX 실습의 `design.md`는 PPTX 생성용 스타일 레퍼런스에 가깝다. 그래서 공식 스펙에 없는 내용도 중요하다.

우리 PPTX용 design.md에 꼭 들어가야 하는 것:

- 표지/도비라/본문/요약 슬라이드 역할
- 상단 바 위치와 높이
- 본문 박스 위치
- 하단 여백 기준
- 캡처 이미지 배치 방식
- 한글 폰트와 굵기 체계
- 한국어 어절 줄바꿈 금지
- 저작권 표시/기관명/민감정보 제거 규칙

따라서 교육에서는 이렇게 설명하면 된다.

> 공식 `DESIGN.md`는 웹 UI 디자인 시스템에 가까운 표준입니다.  
> 우리는 그 개념을 PPTX에 빌려와서, 슬라이드 스타일을 에이전트가 재사용할 수 있는 규칙 문서로 만든 것입니다.  
> 그러니까 파일명이나 형식보다 중요한 것은 "다음에도 같은 스타일을 만들 수 있을 만큼 구체적인 규칙이 들어 있느냐"입니다.

## 6. 여러 디자인을 운영하는 추천 구조

실무에서는 아래 구조가 무난하다.

```text
project/
├─ DESIGN.md                    # 현재 기본 스타일
├─ designs/
│  ├─ 교육PT_A2Z.md
│  ├─ 행정보고서_정돈형.md
│  ├─ 카드뉴스_600x600.md
│  └─ 웹대시보드_업무형.md
├─ AGENTS.md
└─ outputs/
```

`AGENTS.md`에는 이렇게 적어둘 수 있다.

```markdown
## 디자인 규칙

- 별도 지시가 없으면 루트의 `DESIGN.md`를 따른다.
- PPTX 교육자료는 `designs/교육PT_A2Z.md`를 우선 참고한다.
- 행정보고서형 문서는 `designs/행정보고서_정돈형.md`를 참고한다.
- 서로 다른 디자인 파일의 색상/폰트/레이아웃을 섞지 않는다.
```

## 7. 스터디 답변용 짧은 말

질문:

> design.md는 한 가지 템플릿에 대해서만 적용되는 거 아니냐?  
> 다른 디자인은 다른 design.md를 써야 하냐?

답변:

> `design.md` 하나는 보통 한 디자인 시스템을 의미합니다.  
> 그런데 그 안에는 표지, 도비라, 본문, 요약처럼 여러 레이아웃 유형이 들어갈 수 있습니다.  
> 같은 톤의 변형이면 한 파일에 넣어도 되고, 완전히 다른 톤이면 파일을 나누는 게 좋습니다.  
> 핵심은 파일명이 아니라 에이전트가 헷갈리지 않게 "이번 작업은 어떤 디자인 문서를 기준으로 할지"를 분명히 해주는 것입니다.

## 8. 교재 08장에 반영할 문장

교재에는 아래 문장을 추가하면 좋다.

```markdown
`design.md`는 반드시 하나의 슬라이드 템플릿만 뜻하지 않습니다.  
같은 스타일 안에서 쓰이는 표지, 도비라, 본문, 요약 슬라이드 규칙을 한 문서에 함께 넣을 수 있습니다.

다만 교육 PPT, 행정보고서, 카드뉴스처럼 분위기가 완전히 다른 디자인은 서로 다른 design 문서로 나누는 것이 좋습니다.  
그래야 AI가 색상, 폰트, 여백, 문체를 섞지 않습니다.

실무에서는 현재 작업에 쓸 기본 문서를 `DESIGN.md`로 두고, 다른 스타일은 `designs/` 폴더에 보관한 뒤 필요한 파일을 명시해서 사용합니다.
```

## 9. 참고자료

- Google Labs, `Stitch's DESIGN.md format is now open-source so you can use it across platforms`  
  https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-design-md/
- Google Labs Code, `google-labs-code/design.md` GitHub repository  
  https://github.com/google-labs-code/design.md
- Google Labs Code, `docs/spec.md`  
  https://github.com/google-labs-code/design.md/blob/main/docs/spec.md
