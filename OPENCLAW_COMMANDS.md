# OpenClaw CLI 명령어 레퍼런스

> OpenClaw 2026.5.27 (27ae826)  
> 생성일: 2026-05-28

---

## 자주 쓰는 명령어

| 명령어 | 설명 |
|--------|------|
| `openclaw status` | Gateway, 채널, 모델, 세션 상태 확인 |
| `openclaw status --deep` | 전체 심층 상태 확인 |
| `openclaw gateway start` | Gateway 서비스 시작 |
| `openclaw gateway stop` | Gateway 서비스 중지 |
| `openclaw gateway restart` | Gateway 서비스 재시작 |
| `openclaw gateway status` | Gateway 연결 상태 확인 |
| `openclaw gateway run` | Gateway 포그라운드 실행 |
| `openclaw dashboard` | 토큰 포함 Control UI 브라우저 오픈 |
| `openclaw dashboard --no-open` | 대시보드 URL만 출력 (브라우저 열지 않음) |
| `openclaw configure --section model` | 모델/계정 재인증 (Codex OAuth) |
| `openclaw doctor --fix` | 설정 문제 자동 진단 및 수정 |
| `openclaw update` | OpenClaw 업데이트 |

---

## 전체 명령어 목록

### acp — ACP 코딩 에이전트 브릿지

```
openclaw acp [options]
```

Gateway 기반 ACP 브릿지 실행.

| 옵션 | 설명 |
|------|------|
| `--session <key>` | 세션 키 지정 (예: agent:main:main) |
| `--session-label <label>` | 세션 라벨로 지정 |
| `--token <token>` | Gateway 토큰 |
| `--url <url>` | Gateway WebSocket URL |
| `--reset-session` | 첫 실행 전 세션 초기화 |
| `--provenance <mode>` | ACP 출처 모드: off, meta, meta+receipt |

---

### agents — 에이전트 관리

```
openclaw agents <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `add` | 새 에이전트 추가 |
| `list` | 에이전트 목록 |
| `delete` | 에이전트 삭제 |
| `bind` | 에이전트 라우팅 바인딩 추가 |
| `unbind` | 라우팅 바인딩 제거 |
| `bindings` | 라우팅 바인딩 목록 |
| `set-identity` | 에이전트 이름/테마/이모지/아바타 수정 |

---

### approvals — 실행 승인 관리

```
openclaw approvals <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `get` | 실행 승인 스냅샷 가져오기 |
| `set` | JSON 파일로 실행 승인 교체 |
| `allowlist` | 에이전트별 허용 목록 편집 |

---

### backup — 백업

```
openclaw backup <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `create` | 설정/인증/세션/워크스페이스 백업 아카이브 생성 |
| `verify` | 백업 아카이브 유효성 검사 |

---

### capability / infer — 프로바이더 추론

```
openclaw infer <command>
openclaw capability <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `model` | 텍스트 추론 및 모델 카탈로그 |
| `image` | 이미지 생성 및 설명 |
| `audio` | 오디오 트랜스크립션 |
| `tts` | 텍스트 음성 변환 |
| `video` | 비디오 생성 및 설명 |
| `web` | 웹 검색/fetch |
| `embedding` | 임베딩 프로바이더 |
| `list` | 지원 capability ID 목록 |
| `inspect` | 특정 capability 상세 정보 |

---

### channels — 채팅 채널 관리

```
openclaw channels <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 설정된 채널 목록 |
| `list --all` | 설치 가능한 전체 채널 목록 |
| `add` | 채널 추가/업데이트 (가이드 설정) |
| `add --channel telegram --token <token>` | 비대화형 채널 추가 |
| `login --channel whatsapp` | 채널 계정 연결 |
| `logout --channel <name>` | 채널 로그아웃 |
| `remove` | 채널 비활성화/삭제 |
| `status` | 채널 연결 상태 확인 |
| `status --probe` | 채널 상태 프로브 실행 |
| `logs` | 최근 채널 로그 확인 |
| `capabilities` | 프로바이더 지원 기능 확인 |
| `resolve` | 채널/사용자 이름 → ID 변환 |

지원 채널: Telegram, Slack, Discord, WhatsApp, LINE, iMessage, Signal, Mattermost, Matrix, Microsoft Teams 등

---

### config — 설정 관리

```
openclaw config <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `get <path>` | 설정 값 조회 (dot path) |
| `set <path> <value>` | 설정 값 지정 |
| `patch --file <path>` | JSON5 파일로 설정 일괄 패치 |
| `file` | 활성 설정 파일 경로 출력 |
| `schema` | 설정 JSON 스키마 출력 |

---

### configure — 대화형 설정

```
openclaw configure
openclaw configure --section model
openclaw configure --section channels
openclaw configure --section gateway
```

인증, 채널, Gateway, 에이전트 기본값 대화형 설정.

---

### cron — 크론 작업

```
openclaw cron <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 크론 작업 목록 |
| `add` | 크론 작업 추가 |
| `edit` | 크론 작업 수정 |
| `enable` / `disable` | 크론 작업 활성화/비활성화 |
| `rm` | 크론 작업 삭제 |
| `run` | 크론 작업 즉시 실행 (디버그) |
| `runs` | 크론 실행 이력 |
| `status` | 크론 스케줄러 상태 |

---

### daemon — Gateway 서비스 (레거시)

```
openclaw daemon <command>
```

`openclaw gateway`의 레거시 별칭.

| 서브커맨드 | 설명 |
|-----------|------|
| `start` / `stop` / `restart` | 서비스 시작/중지/재시작 |
| `install` / `uninstall` | 서비스 설치/제거 |
| `status` | 서비스 상태 확인 |

---

### dashboard — Control UI

```
openclaw dashboard
openclaw dashboard --no-open
openclaw dashboard --yes
```

| 옵션 | 설명 |
|------|------|
| `--no-open` | URL만 출력, 브라우저 열지 않음 |
| `--yes` | Gateway 자동 시작 (프롬프트 없이) |

---

### devices — 디바이스 페어링

```
openclaw devices <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 대기 중 및 페어링된 디바이스 목록 |
| `approve` | 페어링 요청 승인 |
| `reject` | 페어링 요청 거부 |
| `remove` | 페어링 디바이스 삭제 |
| `revoke` | 역할별 디바이스 토큰 취소 |
| `rotate` | 역할별 디바이스 토큰 갱신 |
| `clear` | 모든 페어링 디바이스 초기화 |

---

### doctor — 진단 및 수정

```
openclaw doctor
openclaw doctor --fix
```

설정, Gateway, 플러그인, 채널 문제 진단 및 자동 수정.

---

### gateway — Gateway 관리 ★

```
openclaw gateway <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `run` | Gateway 포그라운드 실행 |
| `run --force` | 기존 포트 점유 프로세스 제거 후 실행 |
| `start` | Gateway 서비스 시작 |
| `stop` | Gateway 서비스 중지 |
| `restart` | Gateway 서비스 재시작 |
| `status` | 서비스 상태 + 연결 프로브 |
| `install` | LaunchAgent/systemd 서비스 설치 |
| `uninstall` | 서비스 제거 |
| `health` | Gateway 상세 헬스 정보 |
| `probe` | 연결 가능성 + 인증 능력 확인 |
| `stability` | 최근 안정성 진단 |
| `discover` | Bonjour로 주변 Gateway 탐색 |
| `diagnostics` | 지원 진단 내보내기 |
| `usage-cost` | 세션 로그 기반 사용 비용 요약 |
| `call <method>` | Gateway RPC 메서드 직접 호출 |

---

### hooks — 내부 에이전트 훅

```
openclaw hooks <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 전체 훅 목록 |
| `enable` / `disable` | 훅 활성화/비활성화 |
| `info` | 훅 상세 정보 |
| `check` | 훅 적용 가능성 확인 |

---

### memory — 메모리 관리

```
openclaw memory <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `status` | 메모리 인덱스 및 프로바이더 상태 |
| `search <query>` | 메모리 파일 검색 |
| `index` | 메모리 파일 재인덱싱 |
| `promote` | 단기 기억 랭킹 후 MEMORY.md에 추가 |

---

### mcp — MCP 설정

```
openclaw mcp <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 설정된 MCP 서버 목록 |
| `show` | MCP 서버/전체 설정 확인 |
| `set` | MCP 서버 추가/수정 |
| `unset` | MCP 서버 제거 |
| `serve` | MCP stdio로 채널 브릿지 노출 |

---

### models — 모델 관리 ★

```
openclaw models <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 모델 목록 (설정된 것만) |
| `list --all` | 전체 모델 목록 |
| `status` | 설정된 모델 상태 확인 |
| `set <model>` | 기본 모델 설정 |
| `set-image <model>` | 이미지 모델 설정 |
| `auth` | 모델 인증 프로파일 관리 |
| `aliases` | 모델 별칭 관리 |
| `fallbacks` | 모델 폴백 목록 관리 |

---

### plugins — 플러그인 관리

```
openclaw plugins <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 플러그인 목록 |
| `install <spec>` | 플러그인 설치 (경로/npm/git/clawhub) |
| `uninstall <name>` | 플러그인 제거 |
| `enable` / `disable` | 플러그인 활성화/비활성화 |
| `update` | 설치된 플러그인 업데이트 |
| `inspect <name>` | 플러그인 상세 정보 |
| `search <query>` | ClawHub 패키지 검색 |
| `marketplace` | 플러그인 마켓플레이스 확인 |
| `doctor` | 플러그인 로드 문제 진단 |

---

### sessions — 세션 관리

```
openclaw sessions
openclaw sessions --active 120
openclaw sessions --all-agents
openclaw sessions --json
```

| 옵션 | 설명 |
|------|------|
| `--active <minutes>` | 최근 N분 이내 세션만 표시 |
| `--agent <id>` | 특정 에이전트 세션만 표시 |
| `--all-agents` | 전체 에이전트 세션 합산 |
| `--limit <n>` | 최대 N개 세션 표시 |
| `--json` | JSON 출력 |

---

### skills — 스킬 관리

```
openclaw skills <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 사용 가능한 스킬 목록 |
| `info <name>` | 스킬 상세 정보 |
| `install <spec>` | 스킬 설치 (ClawHub/git/로컬) |
| `update` | 설치된 스킬 업데이트 |
| `search <query>` | ClawHub 스킬 검색 |
| `check` | 스킬 준비 상태 확인 |

---

### tasks — 백그라운드 작업

```
openclaw tasks <command>
```

| 서브커맨드 | 설명 |
|-----------|------|
| `list` | 백그라운드 작업 목록 |
| `show <id>` | 특정 작업 상세 |
| `cancel <id>` | 실행 중인 작업 취소 |
| `audit` | 중단/손상 작업 확인 |
| `flow` | TaskFlow 상태 확인 |

---

### update — 업데이트

```
openclaw update
openclaw update --dry-run
openclaw update --channel beta
```

| 서브커맨드 | 설명 |
|-----------|------|
| `status` | 업데이트 채널 및 버전 상태 |
| `wizard` | 대화형 업데이트 마법사 |

---

### 기타 명령어

| 명령어 | 설명 |
|--------|------|
| `openclaw chat` | 로컬 터미널 UI 열기 (`tui --local` 별칭) |
| `openclaw tui` | Gateway 연결 터미널 UI |
| `openclaw qr` | 모바일 페어링 QR 코드 생성 |
| `openclaw onboard` | 초기 설정 가이드 |
| `openclaw setup` | 기본 설정/워크스페이스 초기화 |
| `openclaw reset` | 로컬 설정/상태 초기화 (CLI 유지) |
| `openclaw uninstall` | Gateway 서비스 + 로컬 데이터 제거 |
| `openclaw logs` | Gateway 로그 확인 |
| `openclaw logs --follow` | Gateway 로그 실시간 추적 |
| `openclaw health` | Gateway 상세 헬스 정보 |
| `openclaw docs <query>` | 공식 문서 검색 |
| `openclaw security audit` | 보안 설정 감사 |
| `openclaw security audit --fix` | 보안 문제 자동 수정 |
| `openclaw migrate <provider>` | 다른 에이전트 시스템에서 마이그레이션 |
| `openclaw backup create` | 전체 백업 생성 |
| `openclaw transcripts list` | 저장된 트랜스크립트 목록 |
| `openclaw sandbox list` | 샌드박스 컨테이너 목록 |
| `openclaw nodes list` | 페어링된 노드 목록 |
| `openclaw message send --channel telegram --target @chat --message "Hi"` | 채널로 메시지 전송 |

---

> 공식 문서: https://docs.openclaw.ai/cli
