import Foundation
import Coral

struct Config: Codable {
    var sessionToken: String? = nil
    var webApiServerCredential: WebApiServerCredential? = nil
}

extension Config {
    private func toJson() -> String {
        let encoder = JSONEncoder()
        return String(data: try! encoder.encode(self), encoding: .utf8)!
    }

    func save() throws {
        try self.toJson().write(to: Config.getConfigURL(), atomically: true, encoding: .utf8)
    }

    func remove() throws {
        let fileManager = FileManager()
        try fileManager.removeItem(at: Config.getConfigURL())
    }
}

extension Config {
    static func load() throws -> Config? {
        guard let json = try? String(contentsOf: getConfigURL(), encoding: .utf8) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try decoder.decode(Config.self, from: json.data(using: .utf8)!)
    }

    static func getConfigURL() -> URL {
        var executableURL = Bundle.main.executableURL
        executableURL?.deleteLastPathComponent()
        let configURL = executableURL!.appendingPathComponent("config.txt")
        return configURL
    }
}

class ConfigStorage: CoralStorage {
    var codeVerifier: String?

    func getCodeVerifier() async throws -> String? {
        codeVerifier
    }

    func setCodeVerifier(_ newValue: String?) async throws {
        codeVerifier = newValue
    }

    func getSessionToken() async throws -> String? {
        Load().sessionToken
    }

    func setSessionToken(_ newValue: String?) async throws {
        var config = Load()
        config.sessionToken = newValue
        try? config.save()
    }

    func getWebApiServerCredential() async throws -> WebApiServerCredential? {
        Load().webApiServerCredential 
    }

    func setWebApiServerCredential(_ newValue: WebApiServerCredential?) async throws {
        var config = Load()
        config.webApiServerCredential = newValue
        try? config.save()
    }

    private func Load() -> Config {
        if let config = try? Config.load() {
            return config
        } else {
            return Config()
        }
    }
}