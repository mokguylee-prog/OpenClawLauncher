import AppKit

final class SectionLabelView: NSView {
    init(title: String, width: CGFloat) {
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 24))
        let label = NSTextField(labelWithString: title.uppercased())
        label.font = sysFont(10, .semibold)
        label.textColor = .tertiaryLabelColor
        label.frame = NSRect(x: 16, y: 5, width: width - 32, height: 14)
        addSubview(label)
    }
    required init?(coder: NSCoder) { fatalError() }
}
