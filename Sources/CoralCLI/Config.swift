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

struct ConfigStorage: CoralStorage {
    var codeVerifier: String?
    var sessionToken: String? {
        get { Load().sessionToken }
        set { 
            var config = Load()
            config.sessionToken = newValue
            try? config.save()
        }
    }
    var webApiServerCredential: WebApiServerCredential? {
        get { Load().webApiServerCredential }
        set { 
            var config = Load()
            config.webApiServerCredential = newValue
            try? config.save()
        }
    }

    private func Load() -> Config {
        if let config = try? Config.load() {
            return config
        } else {
            return Config()
        }
    }
}