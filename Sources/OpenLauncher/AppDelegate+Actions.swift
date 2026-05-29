import AppKit

extension AppDelegate {

    // MARK: - Status Display

    func updateStatusDisplay(loadingText: String? = nil) {
        if let text = loadingText {
            headerView?.statusText = text
            headerView?.dotColor = .systemGray
        } else {
            headerView?.statusText = currentState.description
            headerView?.dotColor = currentState.dotColor
        }
        toggleMenuItemView?.title = currentState.toggleTitle
        toggleMenuItemView?.isOn  = currentState == .running
    }

    // MARK: - Gateway Toggle

    @objc func toggleOpenClaw() {
        if currentState == .running {
            updateStatusDisplay(loadingText: "Stopping…")
            runOpenClawCommand(arguments: ["gateway", "stop"]) { [weak self] result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if case .failure(let e) = result { self?.showError(message: e.localizedDescription) }
                    self?.refreshStatus()
                }
            }
        } else {
            openDashboardInTerminal()
        }
    }

    // MARK: - Gateway Actions

    @objc func openGateway() {
        if let url = URL(string: gatewayURLString) {
            NSWorkspace.shared.open(url)
        }
    }

    func copyGatewayURL() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(gatewayURLString, forType: .string)
    }

    func openDashboardInTerminal() {
        let path = NSTemporaryDirectory() + "openclaw_dashboard.command"
        let script = """
        #!/bin/bash
        export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin
        openclaw dashboard
        """
        try? script.write(toFile: path, atomically: true, encoding: .utf8)
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: path)
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
    }

    // MARK: - Account

    @objc func reconnectAccount() {
        let path = NSTemporaryDirectory() + "openclaw_reconnect.command"
        let script = """
        #!/bin/bash
        export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  OpenClaw Codex 계정 재연결"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        openclaw configure --section model
        """
        try? script.write(toFile: path, atomically: true, encoding: .utf8)
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: path)
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
    }

    // MARK: - Help / About

    @objc func showHelp() {
        let alert = NSAlert()
        alert.messageText = "OpenClawLauncher"
        alert.informativeText = """
        macOS 메뉴바에서 OpenClaw Gateway를 제어하는 도구입니다.

        • Gateway URL: 클릭 → 브라우저 열기 / 우클릭 → URL 복사
        • Refresh Status: 메뉴를 닫지 않고 상태 갱신
        • Start OpenClaw Dashboard: 터미널에서 대시보드 오픈
        • Reconnect Account: Codex OAuth 재인증
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")

        let creditView = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 44))
        creditView.wantsLayer = true
        creditView.layer?.backgroundColor = NSColor.black.cgColor
        creditView.layer?.cornerRadius = 7
        let creditLabel = NSTextField(labelWithString: "by 월평동 이상목")
        creditLabel.font = D2Coding.font(ofSize: 17)
        creditLabel.textColor = .white
        creditLabel.alignment = .center
        creditLabel.frame = NSRect(x: 0, y: 9, width: 320, height: 26)
        creditView.addSubview(creditLabel)
        alert.accessoryView = creditView

        alert.runModal()
    }

    // MARK: - Quit

    @objc func quit() { NSApp.terminate(nil) }
}
