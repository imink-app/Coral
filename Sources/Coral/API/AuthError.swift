import Foundation

enum AuthError: Swift.Error {
    case invalidToken
    case tokenExpired
}