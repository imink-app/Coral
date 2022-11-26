import Foundation

public struct WebApiServerCredential: Codable {
    public let accessToken: String
    public let expiresIn: Int64
}
