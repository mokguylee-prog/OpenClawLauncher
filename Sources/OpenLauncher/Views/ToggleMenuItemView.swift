import AppKit

/// Menu item with SF Symbol icon, label, and NSSwitch toggle on the right.
/// Clicking the label OR the switch both trigger onAction.
final class ToggleMenuItemView: NSView {
    private let iconView = NSImageView()
    private let label    = NSTextField(labelWithString: "")
    private let toggle   = NSSwitch()
    var onAction: (() -> Void)?

    var isOn: Bool = false { didSet { toggle.state = isOn ? .on : .off } }
    var title: String = "" { didSet { label.stringValue = title } }

    init(width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 30))

        toggle.target = self
        toggle.action = #selector(switchTapped)
        toggle.sizeToFit()
        let tw = toggle.frame.width
        let th = toggle.frame.height
        toggle.frame = NSRect(x: width - tw - 13, y: (30 - th) / 2, width: tw, height: th)
        addSubview(toggle)

        if let img = symbol("power", size: 13) {
            iconView.image = img
            iconView.contentTintColor = .secondaryLabelColor
        }
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.frame = NSRect(x: 13, y: 7, width: 15, height: 15)
        addSubview(iconView)

        label.font = sysFont(13)
        label.textColor = .labelColor
        label.frame = NSRect(x: 36, y: 6, width: width - tw - 56, height: 17)
        addSubview(label)

        updateTrackingAreas()
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func switchTapped() { onAction?() }

    override func mouseDown(with event: NSEvent) {
        let loc = convert(event.locationInWindow, from: nil)
        if !toggle.frame.contains(loc) { onAction?() }
        // No cancelTracking — menu stays open
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
