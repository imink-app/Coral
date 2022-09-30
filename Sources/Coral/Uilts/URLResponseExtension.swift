import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension URLResponse {
    var httpURLResponse: HTTPURLResponse {
        self as! HTTPURLResponse
    }
}
