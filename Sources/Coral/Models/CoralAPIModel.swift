struct WebServiceTokenBody: Codable {
    var parameter: WebServiceTokenParamemter

    struct WebServiceTokenParamemter: Codable {
        var id: Int64
        var requestId: String
        var registrationToken: String
        var timestamp: Int64
        var f: String
    }
}