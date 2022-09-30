import Foundation

extension Data {
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type.self, from: self)
    }
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(self)
    }
}