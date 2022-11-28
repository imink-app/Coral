import Foundation

public struct WebApiServerCredential: Codable {
    public let accessToken: String
    public let expiresIn: Int64

    public init(accessToken: String, expiresIn: Int64) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
    }
}
