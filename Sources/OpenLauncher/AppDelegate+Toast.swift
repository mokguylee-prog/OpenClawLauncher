import AppKit

extension AppDelegate {

    /// Shows a floating toast message near the cursor, auto-dismisses after ~1.4s.
    func showToast(_ message: String) {
        toastWindow?.orderOut(nil)
        toastWindow = nil

        let w: CGFloat = 130
        let h: CGFloat = 34

        let win = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: w, height: h),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        win.backgroundColor = .clear
        win.isOpaque = false
        win.hasShadow = true
        win.level = .popUpMenu
        win.ignoresMouseEvents = true

        let content = NSView(frame: NSRect(x: 0, y: 0, width: w, height: h))
        content.wantsLayer = true
        content.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.78).cgColor
        content.layer?.cornerRadius = 8
        win.contentView = content

        let lbl = NSTextField(labelWithString: message)
        lbl.font = sysFont(12, .medium)
        lbl.textColor = .white
        lbl.alignment = .center
        lbl.frame = NSRect(x: 0, y: 7, width: w, height: 20)
        content.addSubview(lbl)

        // Position just above the cursor, clamped to screen bounds
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main!
        let x = max(screen.frame.minX + 4, min(mouse.x - w / 2, screen.frame.maxX - w - 4))
        let y = min(mouse.y + 14, screen.frame.maxY - h - 4)
        win.setFrameOrigin(NSPoint(x: x, y: y))

        win.alphaValue = 0
        win.orderFront(nil)
        toastWindow = win

        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.15
            win.animator().alphaValue = 1
        }) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                NSAnimationContext.runAnimationGroup({ ctx in
                    ctx.duration = 0.25
                    win.animator().alphaValue = 0
                }) {
                    win.orderOut(nil)
                    if self?.toastWindow === win { self?.toastWindow = nil }
                }
            }
        }
    }
}
