import AppKit

extension AppDelegate {

    func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.minimumWidth = menuWidth

        // ── Header ──────────────────────────────────────────
        let hv = HeaderView(width: menuWidth)
        let headerItem = NSMenuItem()
        headerItem.view = hv
        headerItem.isEnabled = false
        menu.addItem(headerItem)
        headerView = hv

        // ── GATEWAY section ─────────────────────────────────
        menu.addItem(sectionItem("Gateway"))

        let urlItem = NSMenuItem()
        let urlView = GatewayURLItemView(width: menuWidth)
        urlView.urlString = gatewayURLString
        urlView.onOpen = { [weak self] in self?.openGateway() }
        urlView.onCopy = { [weak self] in
            self?.copyGatewayURL()
            self?.showToast("복사 완료")
        }
        urlItem.view = urlView
        menu.addItem(urlItem)

        let refreshItem = NSMenuItem()
        let refreshView = IconMenuItemView(title: "Refresh Status", symbolName: "arrow.clockwise", width: menuWidth)
        refreshView.closesMenu = false
        refreshView.onAction = { [weak self] in self?.refreshStatus() }
        refreshItem.view = refreshView
        menu.addItem(refreshItem)

        menu.addItem(.separator())

        // ── CONTROLS section ─────────────────────────────────
        menu.addItem(sectionItem("Controls"))

        let toggleItem = NSMenuItem()
        let toggleView = ToggleMenuItemView(width: menuWidth)
        toggleView.title = "Start OpenClaw Dashboard"
        toggleView.isOn  = false
        toggleView.onAction = { [weak self] in self?.toggleOpenClaw() }
        toggleItem.view = toggleView
        menu.addItem(toggleItem)
        toggleMenuItemView = toggleView

        menu.addItem(.separator())

        // ── ACCOUNT section ──────────────────────────────────
        menu.addItem(sectionItem("Account"))

        let reconnectItem = NSMenuItem()
        let reconnectView = IconMenuItemView(title: "Reconnect Account…", symbolName: "key.fill", width: menuWidth)
        reconnectView.onAction = { [weak self] in self?.reconnectAccount() }
        reconnectItem.view = reconnectView
        menu.addItem(reconnectItem)

        let helpItem = NSMenuItem()
        let helpView = IconMenuItemView(title: "About / Help…", symbolName: "info.circle", width: menuWidth)
        helpView.onAction = { [weak self] in self?.showHelp() }
        helpItem.view = helpView
        menu.addItem(helpItem)

        menu.addItem(.separator())

        // ── Footer ───────────────────────────────────────────
        let footerItem = NSMenuItem()
        footerItem.view = makeFooterView()
        menu.addItem(footerItem)

        return menu
    }

    // MARK: - Private helpers

    private func sectionItem(_ title: String) -> NSMenuItem {
        let item = NSMenuItem()
        item.view = SectionLabelView(title: title, width: menuWidth)
        item.isEnabled = false
        return item
    }

    func makeFooterView() -> NSView {
        let h: CGFloat = 36
        let view = NSView(frame: NSRect(x: 0, y: 0, width: menuWidth, height: h))

        let quitBtn = NSButton(title: "", target: self, action: #selector(quit))
        quitBtn.isBordered = false
        quitBtn.attributedTitle = NSAttributedString(string: "종료", attributes: [
            .font: sysFont(12, .medium),
            .foregroundColor: NSColor.controlAccentColor
        ])
        quitBtn.sizeToFit()
        let btnW = quitBtn.frame.width + 4
        quitBtn.frame = NSRect(x: menuWidth - btnW - 14, y: (h - 18) / 2, width: btnW, height: 18)
        view.addSubview(quitBtn)

        let verLabel = NSTextField(labelWithString: "OpenClawLauncher \(version)")
        verLabel.font = sysFont(10.5)
        verLabel.textColor = .tertiaryLabelColor
        verLabel.frame = NSRect(x: 14, y: (h - 15) / 2, width: menuWidth - btnW - 34, height: 15)
        view.addSubview(verLabel)

        return view
    }
}
