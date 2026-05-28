import AppKit

// MARK: - D2Coding 폰트 로더
private enum D2Coding {
    static func font(ofSize size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
        if let font = NSFont(name: "D2Coding", size: size) { return font }
        // 앱 번들에서 로드 시도
        if let url = Bundle.main.url(forResource: "D2Coding", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        return NSFont(name: "D2Coding", size: size) ?? NSFont.systemFont(ofSize: size, weight: weight)
    }
}

// MARK: - Gateway URL 커스텀 메뉴 아이템 뷰 (좌클릭=열기, 우클릭=복사)
private final class GatewayURLItemView: NSView {
    private let label = NSTextField(labelWithString: "")
    var urlString: String = "" {
        didSet { label.stringValue = "Gateway URL: \(urlString)" }
    }
    var onOpen: (() -> Void)?
    var onCopy: (() -> Void)?

    init(width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 26))
        label.font = D2Coding.font(ofSize: 13)
        label.textColor = NSColor.secondaryLabelColor
        label.lineBreakMode = .byTruncatingTail
        label.frame = NSRect(x: 14, y: 4, width: width - 28, height: 18)
        addSubview(label)
        updateTrackingAreas()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func mouseDown(with event: NSEvent) {
        onOpen?()
        enclosingMenuItem?.menu?.cancelTracking()
    }

    override func rightMouseDown(with event: NSEvent) {
        onCopy?()
        enclosingMenuItem?.menu?.cancelTracking()
    }

    private var highlightView: NSVisualEffectView?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        ))
    }

    override func mouseEntered(with event: NSEvent) {
        let vfx = NSVisualEffectView(frame: bounds)
        vfx.material = .selection
        vfx.state = .active
        vfx.blendingMode = .behindWindow
        vfx.autoresizingMask = [.width, .height]
        addSubview(vfx, positioned: .below, relativeTo: label)
        highlightView = vfx
        label.textColor = .selectedMenuItemTextColor
    }

    override func mouseExited(with event: NSEvent) {
        highlightView?.removeFromSuperview()
        highlightView = nil
        label.textColor = NSColor.secondaryLabelColor
    }
}

// MARK: - 클릭해도 메뉴가 닫히지 않는 아이템 뷰
private final class PersistentMenuItemView: NSView {
    private let label = NSTextField(labelWithString: "")
    var onAction: (() -> Void)?

    init(title: String, width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 22))
        label.font = D2Coding.font(ofSize: 14)
        label.textColor = .labelColor
        label.stringValue = title
        label.frame = NSRect(x: 14, y: 2, width: width - 28, height: 18)
        addSubview(label)
        updateTrackingAreas()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func mouseDown(with event: NSEvent) {
        onAction?()
        // cancelTracking() 호출 안 함 → 메뉴 유지
    }

    private var highlightView: NSVisualEffectView?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        ))
    }

    override func mouseEntered(with event: NSEvent) {
        let vfx = NSVisualEffectView(frame: bounds)
        vfx.material = .selection
        vfx.state = .active
        vfx.blendingMode = .behindWindow
        vfx.autoresizingMask = [.width, .height]
        addSubview(vfx, positioned: .below, relativeTo: label)
        highlightView = vfx
        label.textColor = .selectedMenuItemTextColor
    }

    override func mouseExited(with event: NSEvent) {
        highlightView?.removeFromSuperview()
        highlightView = nil
        label.textColor = .labelColor
    }
}

// MARK: - 토글 스위치가 있는 메뉴 아이템 뷰
private final class ToggleMenuItemView: NSView {
    private let label = NSTextField(labelWithString: "")
    private let toggle = NSSwitch()
    var onAction: (() -> Void)?

    var isOn: Bool = false {
        didSet { toggle.state = isOn ? .on : .off }
    }

    var title: String = "" {
        didSet { label.stringValue = title }
    }

    init(width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 30))

        toggle.target = self
        toggle.action = #selector(switchTapped)
        toggle.sizeToFit()
        let tw = toggle.frame.width
        let th = toggle.frame.height
        toggle.frame = NSRect(x: width - tw - 14, y: (30 - th) / 2, width: tw, height: th)
        addSubview(toggle)

        label.font = D2Coding.font(ofSize: 14)
        label.textColor = .labelColor
        label.frame = NSRect(x: 14, y: 6, width: width - tw - 34, height: 18)
        addSubview(label)

        updateTrackingAreas()
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func switchTapped() {
        onAction?()
    }

    override func mouseDown(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        // 스위치 영역 클릭은 switchTapped()가 처리하므로 중복 호출 방지
        if !toggle.frame.contains(loc) {
            onAction?()
        }
        // cancelTracking() 없음 → 메뉴 유지
    }

    private var highlightView: NSVisualEffectView?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        ))
    }

    override func mouseEntered(with event: NSEvent) {
        let vfx = NSVisualEffectView(frame: bounds)
        vfx.material = .selection
        vfx.state = .active
        vfx.blendingMode = .behindWindow
        vfx.autoresizingMask = [.width, .height]
        addSubview(vfx, positioned: .below, relativeTo: label)
        highlightView = vfx
        label.textColor = .selectedMenuItemTextColor
    }

    override func mouseExited(with event: NSEvent) {
        highlightView?.removeFromSuperview()
        highlightView = nil
        label.textColor = .labelColor
    }
}

// MARK: - AppDelegate
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let queue = DispatchQueue(label: "com.openlauncher.openclaw")
    private let pathEnvironment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin"]
    private var currentState: ServiceState = .unknown
    private let version = "V0.3 (2026.05.28)"
    private let gatewayHost = "127.0.0.1"
    private let gatewayPort = 18789

    private var gatewayURLString: String {
        "http://\(gatewayHost):\(gatewayPort)"
    }

    private weak var stateMenuItem: NSMenuItem?
    private weak var toggleMenuItemView: ToggleMenuItemView?
    private var toastWindow: NSWindow?

    enum ServiceState {
        case running, stopped, unknown

        var description: String {
            switch self {
            case .running: return "Running ✓"
            case .stopped: return "Stopped"
            case .unknown: return "Unknown"
            }
        }

        var toggleTitle: String {
            switch self {
            case .running: return "Stop OpenClaw Gateway"
            case .stopped: return "Start OpenClaw Dashboard"
            case .unknown: return "Start OpenClaw Dashboard"
            }
        }

        var dotColor: NSColor {
            switch self {
            case .running: return .systemGreen
            case .stopped: return .systemRed
            case .unknown: return .systemGray
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // D2Coding 폰트 앱 시작 시 등록
        if let url = Bundle.main.url(forResource: "D2Coding", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        NSApp.setActivationPolicy(.accessory)
        statusItem.button?.image = loadStatusIcon()
        statusItem.button?.image?.isTemplate = false
        statusItem.button?.title = "OCL"
        statusItem.button?.toolTip = "OpenClawLauncher: OpenClaw Gateway control"
        statusItem.menu = buildMenu()
        refreshStatus()
    }

    private func loadStatusIcon() -> NSImage {
        guard let iconURL = Bundle.main.url(forResource: "AppIcon", withExtension: "icns"),
              let image = NSImage(contentsOf: iconURL)
        else {
            return NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "OpenClawLauncher") ?? NSImage()
        }
        image.size = NSSize(width: 18, height: 18)
        return image
    }

    private let menuWidth: CGFloat = 290

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        // 상단 상태 표시 (● dot + 상태 텍스트) — 레퍼런스: "● 연결됨 ✓", 14px bold
        let stateItem = NSMenuItem()
        stateItem.isEnabled = false
        stateItem.attributedTitle = makeStateTitle(.unknown)
        menu.addItem(stateItem)
        self.stateMenuItem = stateItem

        menu.addItem(NSMenuItem.separator())

        // Gateway URL: 좌클릭=브라우저 열기, 우클릭=URL 복사
        let urlViewItem = NSMenuItem()
        let urlView = GatewayURLItemView(width: menuWidth)
        urlView.urlString = gatewayURLString
        urlView.onOpen = { [weak self] in self?.openGateway() }
        urlView.onCopy = { [weak self] in
            self?.copyGatewayURL()
            self?.showToast("복사 완료")
        }
        urlViewItem.view = urlView
        menu.addItem(urlViewItem)

        // 메뉴 항목들 — 레퍼런스: "리모컨 열기" 스타일, 15px, 중앙 정렬감, labelColor
        let statusViewItem = NSMenuItem()
        let statusView = PersistentMenuItemView(title: "Status", width: menuWidth)
        statusView.onAction = { [weak self] in self?.refreshStatus() }
        statusViewItem.view = statusView
        menu.addItem(statusViewItem)

        menu.addItem(NSMenuItem.separator())

        let toggleViewItem = NSMenuItem()
        let toggleView = ToggleMenuItemView(width: menuWidth)
        toggleView.title = "Start OpenClaw Dashboard"
        toggleView.isOn = false
        toggleView.onAction = { [weak self] in self?.toggleOpenClaw() }
        toggleViewItem.view = toggleView
        menu.addItem(toggleViewItem)
        self.toggleMenuItemView = toggleView

        menu.addItem(NSMenuItem.separator())

        let reconnectItem = NSMenuItem(title: "Reconnect OpenClaw Account…", action: #selector(reconnectAccount), keyEquivalent: "")
        reconnectItem.target = self
        menu.addItem(reconnectItem)

        let helpItem = NSMenuItem(title: "About / Help…", action: #selector(showHelp), keyEquivalent: "")
        helpItem.target = self
        menu.addItem(helpItem)

        // 하단 바: 버전(좌) + 종료(우)
        let bottomItem = NSMenuItem()
        bottomItem.view = makeBottomBarView()
        menu.addItem(bottomItem)

        // 메뉴 전체에 D2Coding 폰트 적용
        applyFont(to: menu)

        return menu
    }

    // NSMenu 내 일반 항목에 D2Coding 폰트 일괄 적용
    private func applyFont(to menu: NSMenu) {
        for item in menu.items {
            guard item.view == nil, !item.isSeparatorItem else { continue }
            let font = D2Coding.font(ofSize: 14)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: NSColor.labelColor
            ]
            if let existing = item.attributedTitle {
                // 상태 아이템은 건드리지 않음 (dot 색상 유지)
                _ = existing
            } else {
                item.attributedTitle = NSAttributedString(string: item.title, attributes: attrs)
            }
        }
    }

    private func makeStateTitle(_ state: ServiceState, loadingText: String? = nil) -> NSAttributedString {
        let result = NSMutableAttributedString()
        if let loadingText {
            result.append(NSAttributedString(string: loadingText, attributes: [
                .font: D2Coding.font(ofSize: 13),
                .foregroundColor: NSColor.secondaryLabelColor
            ]))
            return result
        }
        // 레퍼런스: "● 연결됨 ✓" — dot 색상 + bold 텍스트
        result.append(NSAttributedString(string: "● ", attributes: [
            .foregroundColor: state.dotColor,
            .font: D2Coding.font(ofSize: 15)
        ]))
        result.append(NSAttributedString(string: "OpenClaw Gateway: \(state.description)", attributes: [
            .font: D2Coding.font(ofSize: 14),
            .foregroundColor: NSColor.labelColor
        ]))
        return result
    }

    private func makeBottomBarView() -> NSView {
        let height: CGFloat = 34
        let view = NSView(frame: NSRect(x: 0, y: 0, width: menuWidth, height: height))

        // 상단 구분선
        let line = NSBox(frame: NSRect(x: 0, y: height - 1, width: menuWidth, height: 1))
        line.boxType = .separator
        view.addSubview(line)

        let quitButton = NSButton(title: "", target: self, action: #selector(quit))
        quitButton.isBordered = false
        quitButton.attributedTitle = NSAttributedString(string: "종료", attributes: [
            .font: D2Coding.font(ofSize: 13),
            .foregroundColor: NSColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        ])
        quitButton.sizeToFit()
        let btnW = quitButton.frame.width + 4
        quitButton.frame = NSRect(x: menuWidth - btnW - 14, y: 7, width: btnW, height: 20)
        view.addSubview(quitButton)

        let versionLabel = NSTextField(labelWithString: "OpenClawLauncher \(version)")
        versionLabel.font = D2Coding.font(ofSize: 11)
        versionLabel.textColor = .secondaryLabelColor
        versionLabel.frame = NSRect(x: 14, y: 8, width: menuWidth - 14 - btnW - 14 - 8, height: 18)
        view.addSubview(versionLabel)

        return view
    }

    // MARK: - Toast (커서 바로 위에 표시)

    private func showToast(_ message: String) {
        toastWindow?.orderOut(nil)
        toastWindow = nil

        let w: CGFloat = 120
        let h: CGFloat = 32

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: w, height: h),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.level = .popUpMenu
        window.ignoresMouseEvents = true

        let content = NSView(frame: NSRect(x: 0, y: 0, width: w, height: h))
        content.wantsLayer = true
        content.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.75).cgColor
        content.layer?.cornerRadius = 7
        window.contentView = content

        let label = NSTextField(labelWithString: message)
        label.font = D2Coding.font(ofSize: 12)
        label.textColor = .white
        label.alignment = .center
        label.frame = NSRect(x: 0, y: 6, width: w, height: 20)
        content.addSubview(label)

        // 커서 바로 위에 위치
        let mouse = NSEvent.mouseLocation
        let x = mouse.x - w / 2
        let y = mouse.y + 12
        // 화면 밖으로 나가지 않도록 클램프
        if let screen = NSScreen.screens.first(where: { NSMouseInRect(mouse, $0.frame, false) }) ?? NSScreen.main {
            let clampedX = max(screen.frame.minX + 4, min(x, screen.frame.maxX - w - 4))
            let clampedY = min(y, screen.frame.maxY - h - 4)
            window.setFrameOrigin(NSPoint(x: clampedX, y: clampedY))
        } else {
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }

        window.alphaValue = 0
        window.orderFront(nil)
        toastWindow = window

        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.15
            window.animator().alphaValue = 1
        }) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                NSAnimationContext.runAnimationGroup({ ctx in
                    ctx.duration = 0.25
                    window.animator().alphaValue = 0
                }) {
                    window.orderOut(nil)
                    if self?.toastWindow === window { self?.toastWindow = nil }
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func toggleOpenClaw() {
        if currentState == .running {
            updateStatusDisplay(loadingText: "Stopping OpenClaw…")
            runOpenClawCommand(arguments: ["gateway", "stop"]) { [weak self] result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    switch result {
                    case .success:
                        self?.refreshStatus()
                    case .failure(let error):
                        self?.showError(message: error.localizedDescription)
                        self?.refreshStatus()
                    }
                }
            }
        } else {
            openDashboardInTerminal()
        }
    }

    @objc private func refreshStatus() {
        updateStatusDisplay(loadingText: "Refreshing status…")
        runOpenClawCommand(arguments: ["gateway", "status"], combineStderr: true) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let output):
                    self?.currentState = Self.state(from: output)
                case .failure(let error):
                    self?.currentState = Self.state(from: error.localizedDescription)
                }
                self?.updateStatusDisplay()
            }
        }
    }

    private func updateStatusDisplay(loadingText: String? = nil) {
        stateMenuItem?.attributedTitle = makeStateTitle(currentState, loadingText: loadingText)
        toggleMenuItemView?.title = currentState.toggleTitle
        toggleMenuItemView?.isOn = currentState == .running
    }

    @objc private func showHelp() {
        let alert = NSAlert()
        alert.messageText = "OpenClawLauncher 도움말"
        alert.informativeText = "OpenClawLauncher는 OpenClaw Gateway를 시작/중지하고 상태를 확인하는 메뉴바 앱입니다.\n\n- Gateway URL: 클릭 → 브라우저 열기, 오른쪽 클릭 → URL 복사\n- 'Start OpenClaw Dashboard': Gateway가 꺼져 있으면 자동으로 시작 후 대시보드 오픈\n- 상태가 'Running'이면 OpenClaw Gateway가 활성화된 상태입니다."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")

        let creditView = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 44))
        creditView.wantsLayer = true
        creditView.layer?.backgroundColor = NSColor.black.cgColor
        creditView.layer?.cornerRadius = 7

        let label = NSTextField(labelWithString: "by 월평동 이상목")
        label.font = D2Coding.font(ofSize: 17)
        label.textColor = .white
        label.alignment = .center
        label.frame = NSRect(x: 0, y: 9, width: 320, height: 26)
        creditView.addSubview(label)

        alert.accessoryView = creditView
        alert.runModal()
    }

    @objc private func openGateway() {
        if let url = URL(string: gatewayURLString) {
            NSWorkspace.shared.open(url)
        }
    }

    private func copyGatewayURL() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(gatewayURLString, forType: .string)
    }

    @objc private func reconnectAccount() {
        let tempPath = NSTemporaryDirectory() + "openclaw_reconnect.command"
        let content = """
        #!/bin/bash
        export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  OpenClaw Codex 계정 재연결"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        openclaw configure --section model
        """
        try? content.write(toFile: tempPath, atomically: true, encoding: .utf8)
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tempPath)
        NSWorkspace.shared.open(URL(fileURLWithPath: tempPath))
    }

    private func openDashboardInTerminal() {
        let tempPath = NSTemporaryDirectory() + "openclaw_dashboard.command"
        let content = """
        #!/bin/bash
        export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin
        openclaw dashboard
        """
        try? content.write(toFile: tempPath, atomically: true, encoding: .utf8)
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tempPath)
        NSWorkspace.shared.open(URL(fileURLWithPath: tempPath))
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    // MARK: - Helpers

    private func runOpenClawCommand(arguments: [String], combineStderr: Bool = false, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["openclaw"] + arguments
            process.environment = self.pathEnvironment
            process.currentDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr

            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                completion(.failure(error))
                return
            }

            let output = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let errorOutput = String(data: stderr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let combined = combineStderr ? output + errorOutput : output

            if process.terminationStatus == 0 {
                completion(.success(combined))
            } else {
                let message = errorOutput.isEmpty ? "Command failed: \(arguments.joined(separator: " "))" : errorOutput
                completion(.failure(NSError(domain: "OpenClawLauncher", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: combined.isEmpty ? message : combined])))
            }
        }
    }

    private func showError(message: String) {
        let alert = NSAlert()
        alert.messageText = "OpenClawLauncher 오류"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.runModal()
    }

    private static func state(from output: String) -> ServiceState {
        let lowercased = output.lowercased()
        for line in lowercased.components(separatedBy: .newlines) {
            if line.hasPrefix("runtime:") {
                if line.contains("running") { return .running }
                if line.contains("stopped") || line.contains("unknown") || line.contains("not") { return .stopped }
            }
        }
        if lowercased.contains("connectivity probe: ok") { return .running }
        if lowercased.contains("not loaded") || lowercased.contains("econnrefused") { return .stopped }
        return .unknown
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
