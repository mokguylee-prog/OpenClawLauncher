---
name: feedback_build_method
description: OpenLauncher는 반드시 build.sh로만 빌드해야 한다. swift build 직접 호출 금지.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1bc159a2-51d0-482f-ab3e-65adf4952a54
---

OpenLauncher 프로젝트는 무조건 `./build.sh`로만 빌드한다. `swift build`를 직접 호출하지 않는다.

**Why:** build.sh가 빌드 외에도 앱 번들 생성, LaunchAgent 등록, 기존 프로세스 종료 및 재실행까지 처리한다. 직접 `swift build`만 하면 이 과정이 누락된다.

**How to apply:** 빌드 요청 시 항상 `bash build.sh` 또는 `./build.sh` 사용. 테스트 빌드라도 동일.
