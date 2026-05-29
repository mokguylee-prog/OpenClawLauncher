import AppKit

/// Gateway URL menu item.
/// Left-click  → open in browser
/// Right-click → copy URL to clipboard
final class GatewayURLItemView: NSView {
    private let iconView = NSImageView()
    private let label    = NSTextField(labelWithString: "")
    private let hint     = NSTextField(labelWithString: "R-click: copy")
    var onOpen: (() -> Void)?
    var onCopy: (() -> Void)?

    var urlString: String = "" { didSet { label.stringValue = urlString } }

    init(width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 28))

        if let img = symbol("globe", size: 12) {
            iconView.image = img
            iconView.contentTintColor = .secondaryLabelColor
        }
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.frame = NSRect(x: 13, y: 6, width: 14, height: 14)
        addSubview(iconView)

        label.font = D2Coding.font(ofSize: 11.5)
        label.textColor = .secondaryLabelColor
        label.lineBreakMode = .byTruncatingTail
        label.frame = NSRect(x: 34, y: 5, width: width - 115, height: 17)
        addSubview(label)

        hint.font = sysFont(10)
        hint.textColor = .tertiaryLabelColor
        hint.alignment = .right
        hint.frame = NSRect(x: width - 100, y: 5, width: 86, height: 17)
        addSubview(hint)

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
        hint.textColor = .selectedMenuItemTextColor
        iconView.contentTintColor = .selectedMenuItemTextColor
    }

    override func mouseExited(with event: NSEvent) {
        hlView?.removeFromSuperview(); hlView = nil
        label.textColor = .secondaryLabelColor
        hint.textColor = .tertiaryLabelColor
        iconView.contentTintColor = .secondaryLabelColor
    }
}
