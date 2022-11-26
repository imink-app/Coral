@testable import Coral

class MemoryStorage: CoralStorage {
    var codeVerifier: String?
    var sessionToken: String?
    var webApiServerCredential: WebApiServerCredential?

    func getCodeVerifier() async throws -> String? {
        codeVerifier
    }

    func setCodeVerifier(_ newValue: String?) async throws {
        codeVerifier = newValue
    }

    func getSessionToken() async throws -> String? {
        sessionToken
    }

    func setSessionToken(_ newValue: String?) async throws {
        sessionToken = newValue
    }

    func getWebApiServerCredential() async throws -> WebApiServerCredential? {
        webApiServerCredential
    }

    func setWebApiServerCredential(_ newValue: WebApiServerCredential?) async throws {
        webApiServerCredential = newValue
    }
}