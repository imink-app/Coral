import ArgumentParser

@main
struct CoralCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "CoralCLI",
        abstract: "Coral client")

    enum CMD: String, ExpressibleByArgument, CaseIterable {
        case login
        case clean
    }

    @Argument(help: "Log In")
    var cmd: CMD

    mutating func run() async throws {
        switch cmd {
        case .login:
            try await login()
        case .clean:
            try clean()
        }
    }
}
