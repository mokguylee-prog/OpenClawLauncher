# Designer Agent

## 역할

- OpenClaw Gateway 제어를 위한 macOS 메뉴바 앱 아키텍처 설계
- Swift 및 AppKit 기반의 상태 표시 및 명령 토글 구현
- 앱 번들 리소스, Info.plist, 아이콘 패키징 설계
- 로그인 시 자동 실행을 위한 LaunchAgent 설정 방식 선택
- 빌드 스크립트와 앱 복사/실행 파이프라인 설계

## 설계 방침

1. 메뉴바 앱은 Dock 아이콘 없이 시스템 상태 표시 아이콘으로 동작한다.
2. `openclaw gateway status`, `openclaw gateway start`, `openclaw gateway stop` 명령을 통해 서비스 상태를 제어한다.
3. `build.sh`는 빌드, `.app` 복사, LaunchAgent 등록, 앱 실행 단계를 자동화한다.
4. 아이콘은 `Resources/AppIcon.icns`로 제공하고, 없으면 `scripts/generate_icon.py`에서 생성한다.
5. 사용자 환경변수 PATH를 명시하여 로그인 항목으로 실행될 때도 OpenClaw CLI를 찾을 수 있도록 한다.
