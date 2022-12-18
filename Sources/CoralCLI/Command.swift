import Foundation
import Coral

func login() async throws {
    Coral.setLogLevel(.trace)

    let version = try await Coral.getVersion()
    let coralSession = try await CoralSession(version: version, authorizationStorage: AuthorizationFileStorage())

    let config = try? Config.load()
    if config == nil {
        // Get codeVerifier and login link
        let loginAddress = try await coralSession.generateLoginAddress()

        print("1.Navigate to this URL in your desktop browser:")
        print("\(loginAddress) \n\n")

        print(
            "2.Log in, right click the \"Select this account\" button, copy the link address, and paste in below:"
        )
        var loginLink: String? = nil
        while loginLink == nil {
            loginLink = readLine()
            if loginLink == nil {
                print("Please paste the link in below:")
            }
        }

        _ = try await coralSession.login(loginLink: loginLink!)
    }

    let gameServices = try await coralSession.getGameServices()
    print(gameServices)
}

func clean() throws {
    let config = try? Config.load()
    try config?.remove()
}
