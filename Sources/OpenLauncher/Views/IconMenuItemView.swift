import AppKit

/// Generic menu item with SF Symbol icon on the left.
/// Set `closesMenu = false` to keep the menu open after click (e.g. Refresh Status).
final class IconMenuItemView: NSView {
    private let iconView = NSImageView()
    private let label    = NSTextField(labelWithString: "")
    var onAction: (() -> Void)?
    var closesMenu = true

    var title: String = "" { didSet { label.stringValue = title } }

    init(title: String, symbolName: String, width: CGFloat, height: CGFloat = 28) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: height))

        if let img = symbol(symbolName, size: 13) {
            iconView.image = img
            iconView.contentTintColor = .secondaryLabelColor
        }
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.frame = NSRect(x: 13, y: (height - 15) / 2, width: 15, height: 15)
        addSubview(iconView)

        label.font = sysFont(13)
        label.textColor = .labelColor
        label.stringValue = title
        label.frame = NSRect(x: 36, y: (height - 17) / 2, width: width - 50, height: 17)
        addSubview(label)

        updateTrackingAreas()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func mouseDown(with event: NSEvent) {
        onAction?()
        if closesMenu { enclosingMenuItem?.menu?.cancelTracking() }
    }

    private var hlView: NSVisualEffectView?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self, userInfo: nil))
    }

    override func mouseEntered(with event: NSEvent) {
        let v = makeSelectionVFX()
        addSubview(v, positioned: .below, relativeTo: iconView)
        hlView = v
        label.textColor = .selectedMenuItemTextColor
        iconView.contentTintColor = .selectedMenuItemTextColor
    }

    override func mouseExited(with event: NSEvent) {
        hlView?.removeFromSuperview(); hlView = nil
        label.textColor = .labelColor
        iconView.contentTintColor = .secondaryLabelColor
    }
}

// MARK: - Shared helper
func makeSelectionVFX(frame: NSRect? = nil) -> NSVisualEffectView {
    let v = NSVisualEffectView()
    v.material = .selection
    v.state = .active
    v.blendingMode = .behindWindow
    v.autoresizingMask = [.width, .height]
    return v
}
