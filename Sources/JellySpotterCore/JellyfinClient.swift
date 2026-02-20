import Foundation

public enum JellyfinClientError: Error, LocalizedError {
    case badResponse
    case unexpectedStatusCode(Int)
    case decodingFailure(String)

    public var errorDescription: String? {
        switch self {
        case .badResponse:
            return "Received an invalid HTTP response."
        case .unexpectedStatusCode(let code):
            return "Unexpected Jellyfin status code: \(code)"
        case .decodingFailure(let context):
            return "Could not decode Jellyfin response (\(context))."
        }
    }
}

public actor JellyfinClient {
    private let config: JellyfinConfig
    private let session: URLSession
    private let decoder = JSONDecoder()

    public init(config: JellyfinConfig, session: URLSession = .shared) {
        self.config = config
        self.session = session
    }

    public func fetchLibraries() async throws -> [MediaLibrary] {
        let path = "Users/\(config.userID)/Views"
        let url = try config.endpoint(path: path)
        let response: JellyfinItemEnvelope = try await send(url: url, context: "libraries")
        return response.items.map {
            MediaLibrary(id: $0.id, name: $0.name, collectionType: $0.collectionType)
        }
    }

    public func fetchContinueWatching(limit: Int = 24) async throws -> [MediaItem] {
        let path = "Users/\(config.userID)/Items/Resume"
        let query = [
            URLQueryItem(name: "Limit", value: String(limit))
        ]
        let url = try config.endpoint(path: path, queryItems: query)
        let response: JellyfinItemEnvelope = try await send(url: url, context: "continue-watching")
        return response.items.map { $0.toMediaItem() }
    }

    public func fetchLatestItems(in libraryID: String, limit: Int = 24) async throws -> [MediaItem] {
        let path = "Users/\(config.userID)/Items/Latest"
        let query = [
            URLQueryItem(name: "ParentId", value: libraryID),
            URLQueryItem(name: "Limit", value: String(limit))
        ]
        let url = try config.endpoint(path: path, queryItems: query)
        let dtoItems: [JellyfinItemDTO] = try await send(url: url, context: "latest-items")
        return dtoItems.map { $0.toMediaItem() }
    }

    public func fetchItemDetails(itemID: String) async throws -> MediaItem {
        let path = "Users/\(config.userID)/Items/\(itemID)"
        let url = try config.endpoint(path: path)
        let dto: JellyfinItemDTO = try await send(url: url, context: "item-details")
        return dto.toMediaItem()
    }

    public func posterURL(for item: MediaItem, maxHeight: Int = 520) throws -> URL? {
        guard item.primaryImageTag != nil else {
            return nil
        }
        let path = "Items/\(item.id)/Images/Primary"
        return try config.endpoint(path: path, queryItems: [
            URLQueryItem(name: "maxHeight", value: String(maxHeight)),
            URLQueryItem(name: "quality", value: "90")
        ])
    }

    public func backdropURL(for item: MediaItem, maxWidth: Int = 1920) throws -> URL? {
        guard item.backdropImageTag != nil else {
            return nil
        }
        let path = "Items/\(item.id)/Images/Backdrop/0"
        return try config.endpoint(path: path, queryItems: [
            URLQueryItem(name: "maxWidth", value: String(maxWidth)),
            URLQueryItem(name: "quality", value: "90")
        ])
    }

    private func send<T: Decodable>(url: URL, context: String) async throws -> T {
        var request = URLRequest(url: url)
        request.setValue(config.apiKey, forHTTPHeaderField: "X-Emby-Token")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw JellyfinClientError.badResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw JellyfinClientError.unexpectedStatusCode(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JellyfinClientError.decodingFailure(context)
        }
    }
}

private struct JellyfinItemEnvelope: Decodable {
    let items: [JellyfinItemDTO]

    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

private struct JellyfinItemDTO: Decodable {
    let id: String
    let name: String
    let overview: String?
    let productionYear: Int?
    let type: String?
    let runTimeTicks: Int64?
    let imageTags: [String: String]?
    let backdropImageTags: [String]?
    let userData: JellyfinUserDataDTO?
    let collectionType: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case overview = "Overview"
        case productionYear = "ProductionYear"
        case type = "Type"
        case runTimeTicks = "RunTimeTicks"
        case imageTags = "ImageTags"
        case backdropImageTags = "BackdropImageTags"
        case userData = "UserData"
        case collectionType = "CollectionType"
    }

    func toMediaItem() -> MediaItem {
        MediaItem(
            id: id,
            title: name,
            overview: overview,
            year: productionYear,
            mediaType: type,
            runtimeTicks: runTimeTicks,
            playedPercentage: userData?.playedPercentage,
            primaryImageTag: imageTags?["Primary"],
            backdropImageTag: backdropImageTags?.first
        )
    }
}

private struct JellyfinUserDataDTO: Decodable {
    let playedPercentage: Double?

    enum CodingKeys: String, CodingKey {
        case playedPercentage = "PlayedPercentage"
    }
}

