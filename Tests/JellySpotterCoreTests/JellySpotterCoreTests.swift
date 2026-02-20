import Foundation
import Testing
@testable import JellySpotterCore

@Test func configTrimsInput() throws {
    let config = try JellyfinConfig(
        baseURL: " http://localhost:8096/ ",
        apiKey: " my-key ",
        userID: " my-user "
    )

    #expect(config.baseURL.absoluteString == "http://localhost:8096")
    #expect(config.apiKey == "my-key")
    #expect(config.userID == "my-user")
}

@Test func endpointIncludesAPIKey() throws {
    let config = try JellyfinConfig(
        baseURL: "http://localhost:8096",
        apiKey: "abc123",
        userID: "user1"
    )
    let url = try config.endpoint(path: "Users/user1/Views")
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

    #expect(components?.path == "/Users/user1/Views")
    #expect(components?.queryItems?.contains(URLQueryItem(name: "api_key", value: "abc123")) == true)
}

