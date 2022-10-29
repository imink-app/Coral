import Foundation

struct Config: Codable {
    let sessionToken: String
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
        print(Config.getConfigURL().absoluteString)
        var isDirectory = ObjCBool(true)
        print(FileManager.default.fileExists(atPath: Config.getConfigURL().absoluteString, isDirectory: &isDirectory))
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
