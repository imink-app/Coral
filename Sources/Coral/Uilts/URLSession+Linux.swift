import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking

    extension URLSession {
        func data(
            for request: URLRequest,
            delegate: URLSessionTaskDelegate? = nil
        ) async throws -> (Data, URLResponse) {
            let content: (Data, URLResponse) = await withCheckedContinuation { continuation in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        logger.error("\(error?.localizedDescription ?? "error")")
                        fatalError()
                    }
                    continuation.resume(returning: (data, response!))
                }.resume()
            }
            return content
        }
    }
#endif
