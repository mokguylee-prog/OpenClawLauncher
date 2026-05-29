import AppKit

func sysFont(_ size: CGFloat, _ weight: NSFont.Weight = .regular) -> NSFont {
    NSFont.systemFont(ofSize: size, weight: weight)
}

func symbol(_ name: String, size: CGFloat = 13) -> NSImage? {
    let cfg = NSImage.SymbolConfiguration(pointSize: size, weight: .regular)
    return NSImage(systemSymbolName: name, accessibilityDescription: nil)?
        .withSymbolConfiguration(cfg)
}
