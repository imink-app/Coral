import Foundation
import InkMoya

#if canImport(Crypto)
    import Crypto
#endif

enum AuthAPI {
    case nsoLookup
    case authorize(codeVerifier: String)
    case sessionToken(codeVerifier: String, sessionTokenCode: String)
    case token(sessionToken: String)
    case me(accessToken: String)
    case login(
        requestId: String,
        accessToken: String,
        naBirthday: String,
        naCountry: String,
        language: String,
        timestamp: Int64,
        f: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .nsoLookup:
            return APIHost.appstore.url
        case .authorize,
            .sessionToken,
            .token:
            return APIHost.accountsNintendoConnect.url
        case .me:
            return APIHost.apiAccountsNintendo.url
        case .login:
            return APIHost.znc.url
        }
    }

    var path: String {
        switch self {
        case .nsoLookup:
            return "/us/lookup"
        case .authorize:
            return "/authorize"
        case .sessionToken:
            return "/api/session_token"
        case .token:
            return "/api/token"
        case .me:
            return "/users/me"
        case .login:
            return "/v3/Account/Login"
        }
    }

    var method: Method {
        switch self {
        case .nsoLookup,
            .authorize,
            .me:
            return .get
        case .sessionToken,
            .token,
            .login:
            return .post
        }
    }

    var querys: [(String, String?)]? {
        switch self {
        case .nsoLookup:
            return [("bundleId", "com.nintendo.znca")]
        case .authorize(let codeVerifier):
            let state = Random.urandom(length: 36).urlSafeBase64EncodedString

            let codeDigest = SHA256.hash(
                data:
                    codeVerifier
                    .replacingOccurrences(of: "=", with: "")
                    .data(using: .utf8)!
            )
            let codeChallenge = Data(codeDigest)
                .urlSafeBase64EncodedString
                .replacingOccurrences(of: "=", with: "")

            return [
                ("state", state),
                ("redirect_uri", "\(Coral.clientUrlScheme)://auth"),
                ("client_id", Coral.clientId),
                ("scope", "openid user user.birthday user.mii user.screenName"),
                ("response_type", "session_token_code"),
                ("session_token_code_challenge", codeChallenge),
                ("session_token_code_challenge_method", "S256"),
                ("theme", "login_form"),
            ]
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        switch self {
        case .authorize:
            return [
                "User-Agent":
                    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.1 Mobile/15E148 Safari/604.1"
            ]
        case .sessionToken,
            .token:
            return [
                "Accept": "application/json",
                "User-Agent": "OnlineLounge/\(Coral.version!) NASDKAPI iOS",
            ]
        case .me(let accessToken):
            return [
                "Accept": "application/json",
                "User-Agent": "OnlineLounge/\(Coral.version!) NASDKAPI iOS",
                "Authorization": "Bearer \(accessToken)",
                "Accept-Encoding": "gzip, deflate, br",
            ]
        case .login:
            return [
                "Accept": "application/json",
                "User-Agent": "com.nintendo.znca/\(Coral.version!) (iOS/14.2)",
                "Authorization": "Bearer",
                "X-Platform": "Android",
                "X-ProductVersion": Coral.version!,
                "Accept-Encoding": "gzip, deflate, br",
            ]
        default:
            return nil
        }
    }

    var data: MediaType? {
        switch self {
        case .sessionToken(let codeVerifier, let sessionTokenCode):
            let codeVerifier = codeVerifier.replacingOccurrences(of: "=", with: "")
            return .form([
                ("client_id", Coral.clientId),
                ("session_token_code", sessionTokenCode),
                ("session_token_code_verifier", codeVerifier),
            ])
        case .token(let sessionToken):
            return .jsonData([
                "client_id": Coral.clientId,
                "session_token": sessionToken,
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer-session-token",
            ])
        case .login(
            let requestId,
            let accessToken,
            let naBirthday,
            let naCountry,
            let language,
            let timestamp,
            let f):
            return .jsonData(
                AccountLoginBody(
                    parameter: AccountLoginParamemter(
                        requestId: requestId,
                        naIdToken: accessToken,
                        naBirthday: naBirthday,
                        naCountry: naCountry,
                        timestamp: timestamp,
                        language: language,
                        f: f
                    )
                )
            )

        default:
            return nil
        }
    }

    var sampleData: Data {
        let path = "/SampleData/\(sampleDataFileName)"
        logger.trace("\(path)")
        let url = Bundle.module.url(forResource: path, withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    var sampleDataFileName: String {
        switch self {
        case .nsoLookup:
            return "nsoLookup"
        case .sessionToken:
            return "sessionToken"
        case .token:
            return "token"
        case .me:
            return "me"
        case .login:
            return "login"
        default:
            return ""
        }
    }
}
