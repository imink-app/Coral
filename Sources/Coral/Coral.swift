import Foundation
import Logging

public typealias LogLevel = Logger.Level

public struct Coral { }

extension Coral {
    static let clientId = "71b963c1b7b6d119"
    public static let clientUrlScheme = "npf\(Coral.clientId)"
}

extension Coral {
    static var version: String? 
    static var logLevel = LogLevel.error

    static func setVersion(_ version: String) {
        Coral.version = version
    }

    public static func setLogLevel(_ logLevel: LogLevel) {
        Coral.logLevel = logLevel
    }
}
