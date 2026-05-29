import AppKit
import CoreText

enum D2Coding {
    static func font(ofSize size: CGFloat) -> NSFont {
        if let f = NSFont(name: "D2Coding", size: size) { return f }
        if let url = Bundle.main.url(forResource: "D2Coding", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        return NSFont(name: "D2Coding", size: size)
            ?? NSFont.monospacedSystemFont(ofSize: size, weight: .regular)
    }
}
