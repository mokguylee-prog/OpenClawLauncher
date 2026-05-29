import AppKit

final class HeaderView: NSView {
    private let iconView   = NSImageView()
    private let titleLabel = NSTextField(labelWithString: "OpenClawLauncher")
    private let statusDot  = NSTextField(labelWithString: "")
    private let vfx        = NSVisualEffectView()

    var dotColor: NSColor = .systemGray { didSet { applyStatus() } }
    var statusText: String = "Unknown"  { didSet { applyStatus() } }

    init(width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 62))

        vfx.material = .headerView
        vfx.blendingMode = .withinWindow
        vfx.state = .active
        vfx.frame = bounds
        vfx.autoresizingMask = [.width, .height]
        addSubview(vfx)

        if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "icns"),
           let img = NSImage(contentsOf: url) {
            iconView.image = img
        }
        iconView.imageScaling = .scaleAxesIndependently
        iconView.wantsLayer = true
        iconView.layer?.cornerRadius = 7
        iconView.layer?.masksToBounds = true
        iconView.frame = NSRect(x: 14, y: 15, width: 32, height: 32)
        addSubview(iconView)

        titleLabel.font = sysFont(14, .semibold)
        titleLabel.textColor = .labelColor
        titleLabel.frame = NSRect(x: 56, y: 32, width: width - 70, height: 18)
        addSubview(titleLabel)

        statusDot.font = sysFont(11)
        statusDot.frame = NSRect(x: 56, y: 14, width: width - 70, height: 16)
        addSubview(statusDot)

        applyStatus()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func applyStatus() {
        let s = NSMutableAttributedString()
        s.append(NSAttributedString(string: "● ", attributes: [
            .foregroundColor: dotColor,
            .font: sysFont(10, .medium)
        ]))
        s.append(NSAttributedString(string: statusText, attributes: [
            .foregroundColor: NSColor.secondaryLabelColor,
            .font: sysFont(11)
        ]))
        statusDot.attributedStringValue = s
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.separatorColor.setFill()
        NSRect(x: 0, y: 0, width: bounds.width, height: 0.5).fill()
    }
}
