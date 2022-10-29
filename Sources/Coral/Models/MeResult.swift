public struct MeResult: Decodable {
    public let id: String
    public let nickname: String
    public let gender: Gender
    public let language: String
    public let country: String
    public let birthday: String

    public enum Gender: String, Decodable {
        case male
        case female
    }
}

