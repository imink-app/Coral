import Foundation

public struct User: Codable {
    public let id: Int64
    public let nsaId: String
    public let imageUri: String
    public let name, supportId: String
    public let isChildRestricted: Bool
    public let etag: String
    public let links: Links
    public let permissions: Permissions
    public let presence: Presence

    public struct Links: Codable {
        public let nintendoAccount: NintendoAccount
        public let friendCode: FriendCode

        public struct NintendoAccount: Codable {
            public let membership: Membership

            public struct Membership: Codable {
                public let active: Bool
            }
        }

        public struct FriendCode: Codable {
            public let regenerable: Bool
            public let regenerableAt: Int
            public let id: String
        }
    }

    public struct Permissions: Codable {
        public let presence: String
    }

    public struct Presence: Codable {
        public let state: String
        public let updatedAt, logoutAt: Int
        public let game: Game

        public struct Game: Codable {}
    }
}
