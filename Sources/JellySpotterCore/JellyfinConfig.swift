import Foundation

public struct JellyfinConfig: Sendable, Equatable {
    public let baseURL: URL
    public let apiKey: String
    public let userID: String

    public init(baseURL: String, apiKey: String, userID: String) throws {
        let trimmedURL = baseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUser = userID.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedURL.isEmpty else {
            throw JellyfinConfigError.emptyBaseURL
        }
        guard !trimmedKey.isEmpty else {
            throw JellyfinConfigError.emptyAPIKey
        }
        guard !trimmedUser.isEmpty else {
            throw JellyfinConfigError.emptyUserID
        }
        guard let parsedURL = URL(string: trimmedURL), parsedURL.scheme != nil else {
            throw JellyfinConfigError.invalidBaseURL(trimmedURL)
        }

        guard var components = URLComponents(url: parsedURL, resolvingAgainstBaseURL: false) else {
            throw JellyfinConfigError.invalidBaseURL(trimmedURL)
        }

        var cleanedPath = components.path
        while cleanedPath.count > 1 && cleanedPath.hasSuffix("/") {
            cleanedPath.removeLast()
        }
        if cleanedPath == "/" {
            cleanedPath = ""
        }

        components.path = cleanedPath
        components.query = nil
        components.fragment = nil

        guard let cleanedURL = components.url else {
            throw JellyfinConfigError.invalidBaseURL(trimmedURL)
        }

        self.baseURL = cleanedURL
        self.apiKey = trimmedKey
        self.userID = trimmedUser
    }

    public func endpoint(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = queryItems + [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = components?.url else {
            throw JellyfinConfigError.invalidEndpoint(path)
        }
        return url
    }
}

public enum JellyfinConfigError: Error, LocalizedError {
    case emptyBaseURL
    case emptyAPIKey
    case emptyUserID
    case invalidBaseURL(String)
    case invalidEndpoint(String)

    public var errorDescription: String? {
        switch self {
        case .emptyBaseURL:
            return "Base URL is required."
        case .emptyAPIKey:
            return "API key is required."
        case .emptyUserID:
            return "User ID is required."
        case .invalidBaseURL(let value):
            return "Invalid base URL: \(value)"
        case .invalidEndpoint(let path):
            return "Could not build endpoint URL for path: \(path)"
        }
    }
}
