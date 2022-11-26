struct LookupResult: Codable {
    let results: [Result]

    struct Result: Codable {
        let version: String
    }
}

struct ConnectSessionTokenResult: Decodable {
    let sessionToken: String
    let code: String
}

struct ConnectTokenResult: Decodable {
    let scope: [String]
    let accessToken: String
    let idToken: String
    let tokenType: String
    let expiresIn: Int64
}

struct APIResult<T: Decodable>: Decodable {
    let status: CoralAPIStatus
    let correlationId: String
    let result: T
}

struct AccountLoginBody: Codable {
    var parameter: AccountLoginParamemter
}

struct AccountLoginParamemter: Codable {
    var requestId: String
    var naIdToken: String
    var naBirthday: String
    var naCountry: String
    var timestamp: Int64
    var language: String
    var f: String
}

// struct WebServiceTokenBody: Codable {
//     var parameter: WebServiceTokenParamemter
// }

// struct WebServiceTokenParamemter: Codable {
//     var id: String
//     var requestId: String
//     var registrationToken: String
//     var timestamp: Int64
//     var f: String
// }
