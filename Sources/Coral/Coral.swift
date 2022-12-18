import Foundation
import Logging
import InkMoya

public typealias LogLevel = Logger.Level

public struct Coral { }

extension Coral {
    static let clientId = "71b963c1b7b6d119"
    public static let clientUrlScheme = "npf\(Coral.clientId)"
}

extension Coral {
    static var logLevel = LogLevel.error

    public static func setLogLevel(_ logLevel: LogLevel) {
        Coral.logLevel = logLevel
    }
    
    public static func getVersion() async throws -> String {
        let apiSession = IMSession.shared
        let (data, res) = try await apiSession.request(api: AuthAPI.nsoLookup)
        if res.statusCode != 200 {
            throw Error.error
        }
        let lookupResult = try data.decode(LookupResult.self)

        guard let firstResult = lookupResult.results.first else {
            throw Error.error
        }

        return firstResult.version
    }
}

extension Coral {
    public enum Error: Swift.Error {
        case error
    }
}
