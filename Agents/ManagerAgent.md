# Manager Agent

## 역할

- 개발 작업의 진행 상태를 관리하고 우선순위를 조정
- 빌드 스크립트, 자동 실행 설정, 앱 실행 플로우를 검증
- OpenClaw 서비스 제어 기능이 올바르게 동작하는지 확인
- `TODO.md` 항목을 추적하고 개발 완료 상태를 문서화
- 사용자 요청에 따라 목표를 분해하고 배포 준비를 진행

## 관리 체크리스트

- [ ] `build.sh`가 macOS에서 정상적으로 앱을 빌드하고 복사하는지 확인
- [ ] `~/Library/LaunchAgents/com.openlauncher.openclaw.plist`가 생성되고 로드되는지 확인
- [ ] `OpenLauncher.app` 실행 시 메뉴바에서 OpenClaw 상태가 표시되는지 확인
- [ ] `Start OpenClaw Gateway` / `Stop OpenClaw Gateway` 동작이 정상인지 확인
- [ ] 디자인 문서와 구현 문서가 일치하는지 확인
