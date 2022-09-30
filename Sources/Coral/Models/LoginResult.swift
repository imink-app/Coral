public struct LoginResult: Decodable {
    public let webApiServerCredential: WebApiServerCredential
    public let user: User
}
