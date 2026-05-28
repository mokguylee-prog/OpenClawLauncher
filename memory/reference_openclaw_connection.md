---
name: reference_openclaw_connection
description: OpenClaw Gateway 연결 방법 및 대시보드 접속 절차 (공식 메뉴얼)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 1bc159a2-51d0-482f-ab3e-65adf4952a54
---

## OpenClaw 연결 방법 (공식 절차)

**1단계: Gateway 시작**
```
openclaw gateway run
```
(백그라운드 서비스는 `openclaw gateway start`)

**2단계: 토큰 포함 대시보드 URL 획득**
```
openclaw dashboard
```
URL만 출력(브라우저 열지 않음):
```
openclaw dashboard --no-open
```

**3단계: 접속**
- 출력된 URL을 직접 열거나
- WebSocket URL과 토큰을 대시보드에 직접 붙여넣기

---

## 연결 오류 시 체크리스트

1. `openclaw status` 또는 `openclaw gateway run` 으로 Gateway 실행 여부 확인
2. WebSocket URL 확인 — HTTPS/Tailscale Serve 뒤에 있으면 `wss://` 사용
3. `openclaw dashboard --no-open` 으로 현재 URL과 인증 정보 재확인

**Why:** 토큰이 만료되거나 Gateway가 재시작되면 URL이 바뀔 수 있음. `--no-open`으로 항상 최신 URL 확인.

**How to apply:** 앱에서 "Open OpenClaw Dashboard" 버튼이 동작하지 않을 때, 또는 Gateway 연결 관련 기능 수정 시 이 절차 참고.
