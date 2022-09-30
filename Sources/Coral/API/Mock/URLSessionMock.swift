import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public class APISessionMock: APISessionType {
    public func request(api targetType: APITargetType) async throws -> (Data, URLResponse) {
        let request = targetType.request

        logger.trace("---- Request ----")
        logger.trace("Path: \(request.url?.absoluteString ?? "")")
        logger.trace("Headers: \(String(describing: request.allHTTPHeaderFields))")
        let response = HTTPURLResponse(url: targetType.url, statusCode: 200, httpVersion: nil, headerFields: nil)
        logger.trace("---- Response ----")
        logger.trace("Json: \(String(data: targetType.sampleData, encoding: .utf8)!) \n\n")

        return (targetType.sampleData, response!)
    }
}
