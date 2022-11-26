public protocol CoralStorage {
    func getCodeVerifier() async throws -> String?
    func setCodeVerifier(_ newValue: String?) async throws

    func getSessionToken() async throws -> String?
    func setSessionToken(_ newValue: String?) async throws

    func getWebApiServerCredential() async throws -> WebApiServerCredential?
    func setWebApiServerCredential(_ newValue: WebApiServerCredential?) async throws
}