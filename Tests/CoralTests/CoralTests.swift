import XCTest

@testable import Coral

final class CoralTests: XCTestCase {
    func testMockData() async throws {
        Coral.setLogLevel(.trace)

        let coralSession: CoralSession = CoralSession(sessionType: APISessionMock())

        let loginAddress = coralSession.generateLoginAddress()
        XCTAssertNotEqual(loginAddress, "")

        let sampleLoginLink = "npf71b963c1b7b6d119://auth#session_state=588baa56d8da004e6aed401319055bb602e49879e686de236f72c8aa72ce439a&session_token_code=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLm5pbnRlbmRvLmNvbSIsInR5cCI6InNlc3Npb25fdG9rZW5fY29kZSIsInN1YiI6IjVmMmNkYTkyYWQ5NmM0ZmEiLCJleHAiOjE2NjQyNjQyNjUsInN0YzpzY3AiOlswLDgsOSwxNywyM10sInN0YzptIjoiUzI1NiIsImlhdCI6MTY2NDI2MzY2NSwianRpIjoiNjIxODg4NzYzNjciLCJhdWQiOiI3MWI5NjNjMWI3YjZkMTE5Iiwic3RjOmMiOiJzdUp4Q3FtdFhGLWtMZGRrSm9EY1RqVFVPX2FSeVhGRDFLbFJnNW53dnpjIn0.0cY9HEeQ44rVJeoYPTUQlSktJhjxr1vNbtDqJcuYG_A&state=XIUHxjgpTSzm2DHIp7b4fXM1-BFyya3easS81IFgS4VGVTB9"
        let sessionToken = try await coralSession.generateSessionToken(loginLink: sampleLoginLink)
        XCTAssertEqual(sessionToken, "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MTFlOWIxOTA1OGUwODRlIiwic3Q6c2NwIjpbMCw4LDksMTcsMjNdLCJleHAiOjE3MjM4NjIyNTQsImp0aSI6OTU2MDMwNDQ1NCwidHlwIjoic2Vzc2lvbl90b2tlbiIsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMubmludGVuZG8uY29tIiwiaWF0IjoxNjYwNzkwMjU0LCJhdWQiOiI3MWI5NjNjMWI3YjZkMTE5In0.s_oX7uHqKVAQdhc5KNzEu3cbiZ5nD3OeuxxwLuNNhB4")

        let loginResult = try await coralSession.login(sessionToken: sessionToken)
        XCTAssertEqual(loginResult.webApiServerCredential.accessToken, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc0NoaWxkUmVzdHJpY3RlZCI6ZmFsc2UsIm1lbWJlcnNoaXAiOnsiYWN0aXZlIjp0cnVlfSwiYXVkIjoiZjQxN2UxdGlianFkOTFjaDk5dTQ5aXd6NXNuOWNoeTMiLCJleHAiOjE2NjA3OTc0NjEsImlhdCI6MTY2MDc5MDI2MSwiaXNzIjoiYXBpLWxwMS56bmMuc3J2Lm5pbnRlbmRvLm5ldCIsInN1YiI6NTA4MjM0MjQ3NzUyOTA4OCwidHlwIjoiaWRfdG9rZW4ifQ.dvnyD1VErTINIwiJsi-HjnRyJiJNrW4aT7Au9zTcnZ8")
    }
}
