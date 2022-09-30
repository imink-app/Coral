import Foundation

enum CoralAPI {
    case friendList(String)
    case announcementList(String)
}

extension CoralAPI: APITargetType {
    var baseURL: URL {
        APIHost.znc.url
    }

    var path: String {
        switch self {
        case .friendList:
            return "/v3/Friend/List"
        case .announcementList:
            return "/v1/Announcement/List"
        }
    }

    var method: APIMethod {
        switch self {
        case .friendList, .announcementList:
            return .post
        }
    }

    var headers: [String: String]? {
        switch self {
        case .friendList(let token),
            .announcementList(let token):
            return [
                "User-Agent": "com.nintendo.znca/\(Coral.version!) (iOS/14.2)",
                "Authorization": "Bearer \(token)",
                "x-platform": "Android",
                "X-ProductVersion": Coral.version!,
                "Accept-Encoding": "gzip, deflate, br",
            ]
        }
    }

    var querys: [(String, String?)]? {
        return nil
    }

    var data: MediaType? {
        switch self {
        default:
            return .jsonData([
                "requestId": UUID().uuidString
            ])
        }
    }

    var sampleDataFileName: String {
        switch self {
        case .friendList:
            return "friendList"
        case .announcementList:
            return "announcementList"
        }
    }
}
