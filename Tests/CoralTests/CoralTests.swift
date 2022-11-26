import XCTest

@testable import Coral
@testable import InkMoya

final class CoralTests: XCTestCase {
    func testMockData() async throws {
        // Coral.setLogLevel(.trace)

        let version = try await Coral.getVersion()
        let coralSession: CoralSession = try await CoralSession(version: version, storage: MemoryStorage(), sessionType: IMSessionMock())

        let loginAddress = try await coralSession.generateLoginAddress()
        XCTAssertNotEqual(loginAddress, "")

        let sampleLoginLink = "npf71b963c1b7b6d119://auth#session_state=588baa56d8da004e6aed401319055bb602e49879e686de236f72c8aa72ce439a&session_token_code=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLm5pbnRlbmRvLmNvbSIsInR5cCI6InNlc3Npb25fdG9rZW5fY29kZSIsInN1YiI6IjVmMmNkYTkyYWQ5NmM0ZmEiLCJleHAiOjE2NjQyNjQyNjUsInN0YzpzY3AiOlswLDgsOSwxNywyM10sInN0YzptIjoiUzI1NiIsImlhdCI6MTY2NDI2MzY2NSwianRpIjoiNjIxODg4NzYzNjciLCJhdWQiOiI3MWI5NjNjMWI3YjZkMTE5Iiwic3RjOmMiOiJzdUp4Q3FtdFhGLWtMZGRrSm9EY1RqVFVPX2FSeVhGRDFLbFJnNW53dnpjIn0.0cY9HEeQ44rVJeoYPTUQlSktJhjxr1vNbtDqJcuYG_A&state=XIUHxjgpTSzm2DHIp7b4fXM1-BFyya3easS81IFgS4VGVTB9"
        // let sessionToken = try await coralSession.generateSessionToken(loginLink: sampleLoginLink)
        // XCTAssertEqual(sessionToken, "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MTFlOWIxOTA1OGUwODRlIiwic3Q6c2NwIjpbMCw4LDksMTcsMjNdLCJleHAiOjE3MjM4NjIyNTQsImp0aSI6OTU2MDMwNDQ1NCwidHlwIjoic2Vzc2lvbl90b2tlbiIsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMubmludGVuZG8uY29tIiwiaWF0IjoxNjYwNzkwMjU0LCJhdWQiOiI3MWI5NjNjMWI3YjZkMTE5In0.s_oX7uHqKVAQdhc5KNzEu3cbiZ5nD3OeuxxwLuNNhB4")

        try await coralSession.login(loginLink: sampleLoginLink)
        // XCTAssertEqual(loginResult.webApiServerCredential.accessToken, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc0NoaWxkUmVzdHJpY3RlZCI6ZmFsc2UsIm1lbWJlcnNoaXAiOnsiYWN0aXZlIjp0cnVlfSwiYXVkIjoiZjQxN2UxdGlianFkOTFjaDk5dTQ5aXd6NXNuOWNoeTMiLCJleHAiOjE2NjA3OTc0NjEsImlhdCI6MTY2MDc5MDI2MSwiaXNzIjoiYXBpLWxwMS56bmMuc3J2Lm5pbnRlbmRvLm5ldCIsInN1YiI6NTA4MjM0MjQ3NzUyOTA4OCwidHlwIjoiaWRfdG9rZW4ifQ.dvnyD1VErTINIwiJsi-HjnRyJiJNrW4aT7Au9zTcnZ8")

        let splatoon3ServiceId: Int64 = 4834290508791808
        let gameServices = try await coralSession.getGameServices()
        XCTAssertEqual(gameServices.count > 0, true)
        let splatoon3GameService = gameServices.first { $0.id == splatoon3ServiceId }!
        XCTAssertEqual(splatoon3GameService.id, splatoon3ServiceId)

        let gameServiceToken = try await coralSession.getGameServiceToken(serviceId: splatoon3GameService.id)
        XCTAssertEqual(gameServiceToken.accessToken, "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IkNlVldlQlV5ZG5hZ1NUcEdUU3JzVng5T2RIZyIsImprdSI6Imh0dHBzOi8vYXBpLWxwMS56bmMuc3J2Lm5pbnRlbmRvLm5ldC92MS9XZWJTZXJ2aWNlL0NlcnRpZmljYXRlL0xpc3QifQ.eyJpc0NoaWxkUmVzdHJpY3RlZCI6ZmFsc2UsImF1ZCI6IjY2MzM2NzcyOTE1NTI3NjgiLCJleHAiOjE2NjU2MDQ1NDksImlhdCI6MTY2NTU4MTE0OSwiaXNzIjoiYXBpLWxwMS56bmMuc3J2Lm5pbnRlbmRvLm5ldCIsImp0aSI6IjRlNGRlYzUzLWMwYTItNDFkOS1iNzcyLTExYmIyM2IzNTI5ZSIsInN1YiI6NTA4MjM0MjQ3NzUyOTA4OCwibGlua3MiOnsibmV0d29ya1NlcnZpY2VBY2NvdW50Ijp7ImlkIjoiN2ZlMDBiZTE3MDEzYzVjYiJ9fSwidHlwIjoiaWRfdG9rZW4iLCJtZW1iZXJzaGlwIjp7ImFjdGl2ZSI6dHJ1ZX19.Qhjj-eHnBnJ2cg62dxFImOyi6xBUHOBQYyaDHCM3ywICXiS-ubtQb_F1osMCn1I-UtHuwytRM2Ce467EctqYQXRyEZVAgZnT3DrtVp62u-HNGlCumQ2EaRxmxa8hnGOdX7xxAPSdyfDaIbjiP87dVjci-443fkAihu8eJNgb3pJNqhj1Ld32y4tn4dKoXVBYX1HDgXJQfI1BkDJV6ayW8vsAcpWAR-JBRMg-rE7MGC5E3DCH1tsEmf5wXvDzce6FfPlMklr2UkygRasurCYZ993FivFzfYRIWi8-pefNPUQP359Hyo1vjlZI9i_K5_TDQYGA36KMNQNx74Z76Dt37w")
    }
}
