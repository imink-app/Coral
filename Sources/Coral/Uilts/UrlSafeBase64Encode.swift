import Foundation

extension Sequence where Iterator.Element == UInt8 {
    var urlSafeBase64EncodedString: String {
        Data(self)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
    }
}
