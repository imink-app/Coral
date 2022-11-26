import Foundation
import Logging
import InkMoya

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public class CoralSession {
    private var apiSession: IMSessionType
    private var storage: CoralStorage

    private let version: String

    private var codeVerifier: String? {
        get { storage.codeVerifier }
        set { storage.codeVerifier = newValue }
    }

    private var sessionToken: String? {
        get { storage.sessionToken }
        set { storage.sessionToken = newValue }
    }

    private var webApiServerCredential: WebApiServerCredential? {
        get { storage.webApiServerCredential }
        set {
            storage.webApiServerCredential = newValue
            configureSession()
        }
    }

    public init(version: String, storage: CoralStorage, sessionType: IMSessionType? = nil) {
        self.version = version
        self.storage = storage

        if let sessionType = sessionType {
            self.apiSession = sessionType
        } else {
            self.apiSession = IMSession.shared
        }

        configureSession()
    }
}

extension CoralSession {
    public func generateLoginAddress() -> String {
        let codeVerifier = generateCodeVerifier()
        logger.trace("codeVerifier: \(codeVerifier)")

        let authorizeAPI = AuthAPI.authorize(codeVerifier: codeVerifier)
        logger.trace("loginAddress: \(authorizeAPI.url.absoluteString)")

        self.codeVerifier = codeVerifier

        return authorizeAPI.url.absoluteString
    }

    public func login(loginLink: String) async throws {
        let sessionToken = try await generateSessionToken(loginLink: loginLink)
        let loginResult = try await getLoginResult(sessionToken: sessionToken)

        self.sessionToken = sessionToken

        self.webApiServerCredential = loginResult.webApiServerCredential
    }

    public func getGameServices() async throws -> [GameService] {
        try await auth {
            let gameServicesResult: APIResult<[GameService]> = try await apiSession.requestHandleCoralError(api: CoralAPI.listWebService)
            return gameServicesResult.result
        }
    }

    public func getGameServiceToken(serviceId: Int64) async throws -> GameServiceToken {
        try await auth {
            guard let accessToken = webApiServerCredential?.accessToken else {
                throw Error.loginRequired
            }

            let fResult = try await getF(token: accessToken, hashMethod: .hash2)

            let getWebServiceTokenAPI = CoralAPI.getWebServiceToken(
                serviceId: serviceId,
                token: accessToken,
                requestId: fResult.requestId,
                timestamp: fResult.timestamp,
                f: fResult.f)
            let gameServiceTokenResult: APIResult<GameServiceToken> = try await apiSession.requestHandleCoralError(api: getWebServiceTokenAPI)
            return gameServiceTokenResult.result
        }
    }
}

extension CoralSession {
    private func configureSession() {
        var plugins = [PluginType]()

        plugins.append(LoginAuthPlugin(version: version))

        if let webApiServerCredential = self.webApiServerCredential {
            plugins.append(CoralTokenPlugin(token: webApiServerCredential.accessToken))
        }

        apiSession.plugins = plugins
    }
}

extension CoralSession {
    private func generateSessionToken(loginLink: String) async throws -> String {
        guard let codeVerifier = storage.codeVerifier else {
            throw Error.codeVerifierIsNotGenerated
        }

        // Parse the login link and extract the SessionTokenCode
        let sessionTokenCode = try getSessionTokenCode(loginLink: loginLink)

        // Request SessionToken API
        let sessionTokenAPI = AuthAPI.sessionToken(
            codeVerifier: codeVerifier, sessionTokenCode: sessionTokenCode)
        let (data, res) = try await apiSession.request(api: sessionTokenAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.coralAPIUnknownError(msg: res.httpURLResponse.description)
        }
        let result = try data.decode(ConnectSessionTokenResult.self)

        return result.sessionToken
    }

    private func getLoginResult(sessionToken: String) async throws -> LoginResult {
        // 1.
        let tokenAPI = AuthAPI.token(sessionToken: sessionToken)
        var (data, res) = try await apiSession.request(api: tokenAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.coralAPIUnknownError(msg: res.httpURLResponse.description)
        }
        let connectTokenResult = try data.decode(ConnectTokenResult.self)

        // 2.
        let meAPI = AuthAPI.me(accessToken: connectTokenResult.accessToken)
        (data, res) = try await apiSession.request(api: meAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.coralAPIUnknownError(msg: res.httpURLResponse.description)
        }
        let meResult = try data.decode(MeResult.self)

        // 3.
        let fResult = try await getF(token: connectTokenResult.accessToken, hashMethod: .hash1)

        // 4.
        let loginAPI = AuthAPI.login(
            requestId: fResult.requestId,
            accessToken: connectTokenResult.accessToken,
            naBirthday: meResult.birthday,
            naCountry: meResult.country,
            language: meResult.language,
            timestamp: fResult.timestamp,
            f: fResult.f
        )
        let loginResult: APIResult<LoginResult> = try await apiSession.requestHandleCoralError(api: loginAPI)
        return loginResult.result
    }

    private func getF(token: String, hashMethod: InkAPI.HashMethod) async throws -> FResult {
        let fAPI = InkAPI.f(accessToken: token, hashMethod: hashMethod)
        let (data, res) = try await apiSession.request(api: fAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.coralAPIUnknownError(msg: res.httpURLResponse.description)
        }
        let fResult = try data.decode(FResult.self)
        return fResult
    }

    private func generateCodeVerifier() -> String {
        Random.urandom(length: 32).urlSafeBase64EncodedString
    }

    private func getSessionTokenCode(loginLink: String) throws -> String {
        guard
            let regex = try? NSRegularExpression(
                pattern: "session_token_code=(.*)&",
                options: []),
            let match = regex.matches(
                in: loginLink,
                options: [],
                range: NSRange(location: 0, length: loginLink.count)
            ).first
        else {
            throw Error.wrongLoginLink
        }

        return NSString(string: loginLink).substring(with: match.range(at: 1))
    }
}

extension CoralSession {
    func auth<T>(_ block: () async throws -> T) async throws -> T where T: Any {
        guard let sessionToken = sessionToken, let _ = webApiServerCredential else {
            throw Error.loginRequired
        }

        do {
            return try await block()
        } catch Error.coralAPIError {
            webApiServerCredential = nil
            let loginResult = try await getLoginResult(sessionToken: sessionToken)
            self.webApiServerCredential = loginResult.webApiServerCredential

            return try await block()
        }
    }
}

extension CoralSession {
    public enum Error: Swift.Error {
        case wrongLoginLink
        case codeVerifierIsNotGenerated
        case sessionTokenNoExist
        case loginRequired

        case coralAPIError(body: String)
        case coralAPIUnknownError(msg: String)
    }
}
