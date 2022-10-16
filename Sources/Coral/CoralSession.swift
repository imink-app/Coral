import Foundation
import Logging
import InkMoya

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public class CoralSession {
    public var apiSession: IMSessionType = IMSession.shared

    private var generatedCodeVerifier: String? = nil
    public var coralAccessToken: String? = nil

    public init(sessionType: IMSessionType? = nil, codeVerifier: String? = nil) {
        if let sessionType = sessionType {
            self.apiSession = sessionType
        }
        if let codeVerifier = codeVerifier {
            generatedCodeVerifier = codeVerifier
        }
    }
}

extension CoralSession {
    public func getCoralVersion() async throws -> String {
        let (data, res) = try await apiSession.request(api: AuthAPI.nsoLookup)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let lookupResult = try data.decode(LookupResult.self)

        guard let firstResult = lookupResult.results.first else {
            throw Error.error
        }

        return firstResult.version
    }
    
    public func generateLoginAddress() -> String {
        generatedCodeVerifier = generateCodeVerifier()
        logger.trace("codeVerifier: \(generatedCodeVerifier!)")

        let authorizeAPI = AuthAPI.authorize(codeVerifier: generatedCodeVerifier!)
        logger.trace("loginAddress: \(authorizeAPI.url.absoluteString)")

        return authorizeAPI.url.absoluteString
    }

    public func generateSessionToken(loginLink: String) async throws -> String {
        guard let codeVerifier = generatedCodeVerifier else {
            throw Error.codeVerifierIsNotGenerated
        }

        // Parse the login link and extract the SessionTokenCode
        let sessionTokenCode = try getSessionTokenCode(loginLink: loginLink)

        Coral.setVersion(try await getCoralVersion())

        return try await getSessionToken(sessionTokenCode: sessionTokenCode, codeVerifier: codeVerifier)
    }

    public func login(sessionToken: String) async throws -> LoginResult {
        if Coral.version == nil {
            Coral.setVersion(try await getCoralVersion())
        }

        let loginResult = try await getLoginResult(sessionToken: sessionToken)
        coralAccessToken = loginResult.webApiServerCredential.accessToken
        return loginResult
    }

    public func getGameServices() async throws -> [GameService] {
        if Coral.version == nil {
            Coral.setVersion(try await getCoralVersion())
        }

        guard let coralAccessToken = coralAccessToken else {
            throw Error.loginRequired
        }

        let listWebServiceAPI = CoralAPI.listWebService(token: coralAccessToken)
        let (data, res) = try await apiSession.request(api: listWebServiceAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let gameServicesResult = try data.decode(APIResult<[GameService]>.self)
        return gameServicesResult.result
    }

    public func getGameServiceToken(serviceId: Int64) async throws -> GameServiceToken {
        if Coral.version == nil {
            Coral.setVersion(try await getCoralVersion())
        }

        guard let coralAccessToken = coralAccessToken else {
            throw Error.loginRequired
        }

        let fResult = try await getF(token: coralAccessToken, hashMethod: .hash1)

        let getWebServiceTokenAPI = CoralAPI.getWebServiceToken(
            serviceId: serviceId,
            token: coralAccessToken,
            requestId: fResult.requestId,
            timestamp: fResult.timestamp,
            f: fResult.f)
        let (data, res) = try await apiSession.request(api: getWebServiceTokenAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let gameServiceToken = try data.decode(APIResult<GameServiceToken>.self)
        return gameServiceToken.result
    }
}

extension CoralSession {
    private func getSessionToken(sessionTokenCode: String, codeVerifier: String) async throws -> String {
        // Request SessionToken API
        let sessionTokenAPI = AuthAPI.sessionToken(
            codeVerifier: codeVerifier, sessionTokenCode: sessionTokenCode)
        let (data, res) = try await apiSession.request(api: sessionTokenAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let result = try data.decode(ConnectSessionTokenResult.self)

        return result.sessionToken
    }

    private func getLoginResult(sessionToken: String) async throws -> LoginResult {
        // 1.
        let tokenAPI = AuthAPI.token(sessionToken: sessionToken)
        var (data, res) =
            try await apiSession.request(api: tokenAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let connectTokenResult = try data.decode(ConnectTokenResult.self)

        // 2.
        let meAPI = AuthAPI.me(accessToken: connectTokenResult.accessToken)
        (data, res) = try await apiSession.request(api: meAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
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
        (data, res) = try await apiSession.request(api: loginAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
        }
        let loginResult = try data.decode(APIResult<LoginResult>.self)

        return loginResult.result
    }

    private func getF(token: String, hashMethod: InkAPI.HashMethod) async throws -> FResult {
        let fAPI = InkAPI.f(accessToken: token, hashMethod: hashMethod)
        let (data, res) = try await apiSession.request(api: fAPI)
        if res.httpURLResponse.statusCode != 200 {
            throw Error.error
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
    public enum Error: Swift.Error {
        case wrongLoginLink
        case codeVerifierIsNotGenerated
        case error
        case coralVersionNotFound
        case loginRequired
    }
}
