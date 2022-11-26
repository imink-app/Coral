// From NSO for Android, com.nintendo.coral.core.network.exception.CoralApiStatus
enum CoralAPIStatus: Int, Decodable {
    case success = 0
    case badRequest = 9400
    case methodNotAllowed = 9401
    case resourceNotFound = 9402
    case invalidToken = 9403
    case tokenExpired = 9404
    case forbidden = 9405
    case unauthorized = 9406
    case nsaNotLinked = 9407
    case applicationIdNotSupported = 9409
    case eventNotActivatedError = 9412
    case notJoinedVoiceChatError = 9416
    case duplicateApplicationIdError = 9417
    case operationNotAllowedError = 9422
    case ratingAgeError = 9423
    case userNotActivatedError = 9424
    case invitationLimitExceededError = 9425
    case multipleLoginError = 9426
    case upgradeRequiredError = 9427
    case accountDisabledError = 9428
    case membershipRequiredError = 9450
    case serviceClosedError = 9499
    case internalServerError = 9500
    case serviceUnavailable = 9501
    case maintenanceError = 9511
    case unexpectedError = 9599
    case unknown = -1
}