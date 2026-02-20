import Foundation
import JellySpotterCore

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var continueWatching: [MediaItem] = []
    @Published var shelves: [HomeShelf] = []

    private var config: JellyfinConfig?

    func load(config: JellyfinConfig) async {
        self.config = config
        isLoading = true
        errorMessage = nil

        let client = JellyfinClient(config: config)
        let service = HomeDataService(client: client)

        do {
            let feed = try await service.loadHomeFeed()
            continueWatching = feed.continueWatching
            shelves = feed.shelves
        } catch {
            errorMessage = error.localizedDescription
            continueWatching = []
            shelves = []
        }

        isLoading = false
    }

    func posterURL(for item: MediaItem) -> URL? {
        guard let config else { return nil }
        guard item.primaryImageTag != nil else { return nil }
        return try? config.endpoint(path: "Items/\(item.id)/Images/Primary", queryItems: [
            URLQueryItem(name: "maxHeight", value: "520"),
            URLQueryItem(name: "quality", value: "90")
        ])
    }

    func backdropURL(for item: MediaItem) -> URL? {
        guard let config else { return nil }
        guard item.backdropImageTag != nil else { return nil }
        return try? config.endpoint(path: "Items/\(item.id)/Images/Backdrop/0", queryItems: [
            URLQueryItem(name: "maxWidth", value: "1920"),
            URLQueryItem(name: "quality", value: "85")
        ])
    }
}

