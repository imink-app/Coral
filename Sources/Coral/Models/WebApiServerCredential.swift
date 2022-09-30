public struct WebApiServerCredential: Decodable {
    public let accessToken: String
    public let expiresIn: Int64
}
