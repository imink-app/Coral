public class AuthorizationMemoryStorage: CoralAuthorizationStorage {
    var codeVerifier: String?
    var sessionToken: String?
    var webApiServerCredential: WebApiServerCredential?

    public init() { }

    public func getCodeVerifier() async throws -> String? {
        codeVerifier
    }

    public func setCodeVerifier(_ newValue: String?) async throws {
        codeVerifier = newValue
    }

    public func getSessionToken() async throws -> String? {
        sessionToken
    }

    public func setSessionToken(_ newValue: String?) async throws {
        sessionToken = newValue
    }

    public func getWebApiServerCredential() async throws -> WebApiServerCredential? {
        webApiServerCredential
    }

    public func setWebApiServerCredential(_ newValue: WebApiServerCredential?) async throws {
        webApiServerCredential = newValue
    }
}