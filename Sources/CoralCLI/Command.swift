import Foundation
import Coral

func login() async throws {
    Coral.setLogLevel(.trace)

    let version = try await Coral.getVersion()
    let coralSession = CoralSession(version: version)

    var config = try? Config.load()
    if config == nil {
        // Get codeVerifier and login link
        let loginAddress = coralSession.generateLoginAddress()

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

        let sessionToken = try await coralSession.generateSessionToken(loginLink: loginLink!)

        // Save to file
        config = Config(sessionToken: sessionToken)
        try config!.save()
    }

    let result = try await coralSession.login(sessionToken: config!.sessionToken)
    print(result.webApiServerCredential.accessToken)
}
