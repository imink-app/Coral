import Foundation
import InkMoya

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

fileprivate struct Result: Decodable {
    let status: CoralAPIStatus
    let correlationId: String
}

extension IMSessionType {
    func requestHandleCoralError<T: Decodable>(api targetType: TargetType) async throws -> APIResult<T> {
        let (data, _) = try await request(api: targetType)
        let body = String(data: data, encoding: .utf8)
        let result = try data.decode(Result.self)
        if result.status != .success {
            throw CoralSession.Error.coralAPIError(body: body!)
        }
        return try data.decode(APIResult<T>.self)
    }
}