public struct MeResult: Decodable {
    let id: String
    let nickname: String
    let gender: Gender
    let language: String
    let country: String
    let birthday: String

    public enum Gender: String, Decodable {
        case male
        case female
    }
}

