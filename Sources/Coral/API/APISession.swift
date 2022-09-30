import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public protocol APISessionType {
    func request(api targetType: APITargetType) async throws -> (Data, URLResponse)
}

struct APISession: APISessionType {
    static var shared: APISession = APISession(urlSession: URLSession.shared)

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func request(api targetType: APITargetType) async throws -> (Data, URLResponse) {
        if Coral.version == nil, targetType.url.path != "/us/lookup" {
            throw Error.coralVersionNotFound
        }

        let request = targetType.request

        logger.trace("---- Request ----")
        logger.trace("Path: \(request.url?.absoluteString ?? "")")
        logger.trace("Headers: \(String(describing: request.allHTTPHeaderFields))")
        if let httpBody = request.httpBody {
            logger.trace("Body: \(String(data: httpBody, encoding: .utf8)!)")
        }

        let (data, res) = try await urlSession.data(for: request)

        logger.trace("---- Response ----")
        logger.trace("Json: \(String(data: data, encoding: .utf8)!) \n\n")

        return (data, res)
    }
}

extension APISession {
    public enum Error: Swift.Error {
        case coralVersionNotFound
    }
}
