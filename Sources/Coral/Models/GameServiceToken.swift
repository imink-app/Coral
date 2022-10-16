public struct GameServiceToken: Decodable {
    public let accessToken: String
    public let expiresIn: Int64
}