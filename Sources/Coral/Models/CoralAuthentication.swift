public protocol CoralStorage {
    var codeVerifier: String? { get set }
    var sessionToken: String? { get set }
    var webApiServerCredential: WebApiServerCredential? { get set }
}