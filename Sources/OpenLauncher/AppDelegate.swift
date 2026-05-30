import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Constants
    let menuWidth: CGFloat  = 300
    let gatewayHost         = "127.0.0.1"
    let gatewayPort         = 18789
    let version             = "V0.5 (2026.05.30)"
    let pathEnvironment     = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/sbin"]

    var gatewayURLString: String { "http://\(gatewayHost):\(gatewayPort)" }

    // MARK: - State
    let statusItem  = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let queue       = DispatchQueue(label: "com.openclawlauncher.openclaw")
    var currentState: ServiceState = .unknown

    // MARK: - Menu weak refs (updated by updateStatusDisplay)
    weak var headerView: HeaderView?
    weak var toggleMenuItemView: ToggleMenuItemView?
    var toastWindow: NSWindow?

    // MARK: - Lifecycle
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let url = Bundle.main.url(forResource: "D2Coding", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        NSApp.setActivationPolicy(.accessory)
        setupStatusItem()
        statusItem.menu = buildMenu()
        refreshStatus()
    }

    private func setupStatusItem() {
        if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "icns"),
           let img = NSImage(contentsOf: url) {
            img.size = NSSize(width: 16, height: 16)
            statusItem.button?.image = img
            statusItem.button?.image?.isTemplate = false
        }
        statusItem.button?.title = " OCL"
        statusItem.button?.font = sysFont(12, .medium)
        statusItem.button?.toolTip = "OpenClawLauncher"
    }
}

// MARK: - ServiceState
extension AppDelegate {
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
            default:       return "Start OpenClaw Dashboard"
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
}
