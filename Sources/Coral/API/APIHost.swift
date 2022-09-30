import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

enum APIHost {
    case appstore
    case accountsNintendoConnect
    case apiAccountsNintendo
    case znc
    case imink
}

extension APIHost {
    var url: URL {
        URL(string: string)!
    }

    var string: String {
        switch self {
        case .appstore:
            return "https://itunes.apple.com"
        case .accountsNintendoConnect:
            return "https://accounts.nintendo.com/connect/1.0.0"
        case .apiAccountsNintendo:
            return "https://api.accounts.nintendo.com/2.0.0"
        case .znc:
            return "https://api-lp1.znc.srv.nintendo.net"
        case .imink:
            return "https://api.imink.app"
        }
    }
}
