import AppKit

extension AppDelegate {

    // MARK: - Refresh Gateway Status

    @objc func refreshStatus() {
        updateStatusDisplay(loadingText: "Refreshing…")
        runOpenClawCommand(arguments: ["gateway", "status"], combineStderr: true) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let output): self?.currentState = Self.parseState(from: output)
                case .failure(let error):  self?.currentState = Self.parseState(from: error.localizedDescription)
                }
                self?.updateStatusDisplay()
            }
        }
    }

    // MARK: - Command Runner

    func runOpenClawCommand(
        arguments: [String],
        combineStderr: Bool = false,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        queue.async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["openclaw"] + arguments
            process.environment = self.pathEnvironment
            process.currentDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError  = stderr

            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                completion(.failure(error))
                return
            }

            let out  = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let err  = String(data: stderr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let body = combineStderr ? out + err : out

            if process.terminationStatus == 0 {
                completion(.success(body))
            } else {
                let msg = err.isEmpty ? "Command failed: \(arguments.joined(separator: " "))" : err
                completion(.failure(NSError(
                    domain: "OpenClawLauncher",
                    code: Int(process.terminationStatus),
                    userInfo: [NSLocalizedDescriptionKey: body.isEmpty ? msg : body]
                )))
            }
        }
    }

    // MARK: - State Parser

    static func parseState(from output: String) -> ServiceState {
        let low = output.lowercased()
        for line in low.components(separatedBy: .newlines) {
            if line.hasPrefix("runtime:") {
                if line.contains("running") { return .running }
                if line.contains("stopped") || line.contains("unknown") || line.contains("not") { return .stopped }
            }
        }
        if low.contains("connectivity probe: ok") { return .running }
        if low.contains("not loaded") || low.contains("econnrefused") { return .stopped }
        return .unknown
    }

    // MARK: - Error Alert

    func showError(message: String) {
        let alert = NSAlert()
        alert.messageText = "OpenClawLauncher 오류"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
