import Foundation
import InkMoya

enum CoralAPI {
    case friendList
    case announcementList
    case listWebService
    case getWebServiceToken(serviceId: Int64, token: String, requestId: String, timestamp: Int64, f: String)
}

extension CoralAPI: TargetType {
    var baseURL: URL {
        APIHost.znc.url
    }

    var path: String {
        switch self {
        case .friendList:
            return "/v3/Friend/List"
        case .announcementList:
            return "/v1/Announcement/List"
        case .listWebService:
            return "/v1/Game/ListWebServices"
        case .getWebServiceToken:
            return "/v2/Game/GetWebServiceToken"
        }
    }

    var method: RequestMethod {
        switch self {
        case .friendList, .announcementList, .listWebService, .getWebServiceToken:
            return .post
        }
    }

    var headers: [String: String]? {
        switch self {
        case .friendList,
            .announcementList,
            .listWebService,
            .getWebServiceToken:
            return [
                "x-platform": "Android",
                "Accept-Encoding": "gzip, deflate, br",
            ]
        }
    }

    var querys: [(String, String?)]? {
        return nil
    }

    var data: MediaType? {
        switch self {
        case .getWebServiceToken(let serviceId, let token, let requestId, let timestamp, let f):
            return .jsonData(
                WebServiceTokenBody(
                    parameter: WebServiceTokenBody.WebServiceTokenParamemter(
                        id: serviceId,
                        requestId: requestId,
                        registrationToken: token,
                        timestamp: timestamp,
                        f: f)
                )
            )
        default:
            return .jsonData([
                "requestId": UUID().uuidString
            ])
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
        case .friendList:
            return "friendList"
        case .announcementList:
            return "announcementList"
        case .listWebService:
            return "listWebService"
        case .getWebServiceToken:
            return "getWebServiceToken"
        }
    }
}
