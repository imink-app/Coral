import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public protocol APITargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
    var querys: [(String, String?)]? { get }
    var data: MediaType? { get }
    var sampleDataFileName: String { get }
}

extension APITargetType {
    public var url: URL {
        let url = baseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if let querys = querys {
            let queryItems = querys.map { name, value in
                URLQueryItem(name: name, value: value)
            }
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url!
    }

    public var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let headers = self.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let data = self.data {
            switch data {
            case .jsonData(let data):
                request.addValue(
                    "application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = data.toJSONData()
            case .form(let form):
                request.addValue(
                    "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let queryItems = form.map { name, value in
                    URLQueryItem(name: name, value: value)
                }
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
                urlComponents.queryItems = queryItems
                request.httpBody = urlComponents.query?.data(using: .utf8)
            }
        }

        return request
    }

    public var sampleData: Data {
        let path = "/Mock/SampleData/\(sampleDataFileName)"
        logger.trace("\(path)")
        let url = Bundle.module.url(forResource: path, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
