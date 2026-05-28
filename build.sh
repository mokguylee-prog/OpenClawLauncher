#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$PWD"

if [ ! -f "Sources/OpenLauncher/Resources/AppIcon.icns" ]; then
  echo "Generating AppIcon.icns..."
  python3 scripts/generate_icon.py
fi

echo "Building OpenClawLauncher executable..."
swift build -c release
BIN_DIR=$(swift build -c release --show-bin-path | tr -d '\n')
EXECUTABLE="$BIN_DIR/OpenClawLauncher"
if [ ! -f "$EXECUTABLE" ]; then
  echo "Build failed: executable not found at $EXECUTABLE"
  exit 1
fi

APP_BUNDLE="${PROJECT_ROOT}/OpenClawLauncher.app"
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"
cp "$EXECUTABLE" "$APP_BUNDLE/Contents/MacOS/OpenClawLauncher"
chmod +x "$APP_BUNDLE/Contents/MacOS/OpenClawLauncher"
cp "$PROJECT_ROOT/Resources/Info.plist" "$APP_BUNDLE/Contents/Info.plist"
cp "$PROJECT_ROOT/Sources/OpenLauncher/Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
echo "Created app bundle at $APP_BUNDLE"

LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
# 이전 이름 plist 정리
OLD_PLIST="$LAUNCH_AGENT_DIR/com.openlauncher.openclaw.plist"
if [ -f "$OLD_PLIST" ]; then
  launchctl unload -w "$OLD_PLIST" 2>/dev/null || true
  rm -f "$OLD_PLIST"
fi
LAUNCH_AGENT_PLIST="$LAUNCH_AGENT_DIR/com.openclawlauncher.openclaw.plist"
mkdir -p "$LAUNCH_AGENT_DIR"
cat > "$LAUNCH_AGENT_PLIST" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openclawlauncher.openclaw</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PROJECT_ROOT/OpenClawLauncher.app/Contents/MacOS/OpenClawLauncher</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/OpenClawLauncher.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/OpenClawLauncher.stderr.log</string>
</dict>
</plist>
EOF

sed -i '' "s|\$PROJECT_ROOT|${PROJECT_ROOT}|g" "$LAUNCH_AGENT_PLIST"

if launchctl list | grep -q "com.openclawlauncher.openclaw"; then
  launchctl unload -w "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
fi
launchctl load -w "$LAUNCH_AGENT_PLIST"

echo "Installed login launch agent: $LAUNCH_AGENT_PLIST"

# Kill any currently running OpenClawLauncher process before launching a new copy.
if pgrep -f "$PROJECT_ROOT/OpenClawLauncher.app/Contents/MacOS/OpenClawLauncher" >/dev/null 2>&1; then
  echo "Stopping running OpenClawLauncher process..."
  pkill -f "$PROJECT_ROOT/OpenClawLauncher.app/Contents/MacOS/OpenClawLauncher" || true
  sleep 1
fi

open "$PROJECT_ROOT/OpenClawLauncher.app"
echo "OpenClawLauncher launched. It will also start automatically at login."
