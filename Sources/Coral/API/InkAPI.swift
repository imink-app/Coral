import Foundation

enum InkAPI {
    case f(accessToken: String, hashMethod: HashMethod)

    internal enum HashMethod: String {
        case hash1 = "1", hash2 = "2"
    }
}

extension InkAPI: APITargetType {
    var baseURL: URL {
        APIHost.imink.url 
    }

    var path: String {
        switch self {
        case .f:
            return "/f"
        }
    }

    var method: APIMethod {
        switch self {
        case .f:
            return .post
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var querys: [(String, String?)]? {
        return nil
    }

    var data: MediaType? {
        switch self {
        case .f(let accessToken, let hashMethod):
            return .jsonData([
                "token": accessToken,
                "hash_method": hashMethod.rawValue,
            ])
        }
    }

    var sampleDataFileName: String {
        switch self {
        case .f:
            return "f"
        }
    }
}
