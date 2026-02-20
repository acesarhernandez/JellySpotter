import Foundation

public actor HomeDataService {
    private let client: JellyfinClient

    public init(client: JellyfinClient) {
        self.client = client
    }

    public func loadHomeFeed(maxLibraries: Int = 4, shelfSize: Int = 24) async throws -> HomeFeed {
        let libraries = try await client.fetchLibraries()
        let selectedLibraries = Array(libraries.prefix(maxLibraries))
        let continueWatching = try await client.fetchContinueWatching(limit: shelfSize)

        let indexedShelves: [(Int, HomeShelf)] = try await withThrowingTaskGroup(
            of: (Int, HomeShelf).self,
            returning: [(Int, HomeShelf)].self
        ) { group in
            for (index, library) in selectedLibraries.enumerated() {
                group.addTask {
                    let items = try await self.client.fetchLatestItems(in: library.id, limit: shelfSize)
                    return (index, HomeShelf(id: library.id, title: library.name, items: items))
                }
            }

            var collected: [(Int, HomeShelf)] = []
            for try await shelf in group {
                collected.append(shelf)
            }
            return collected
        }

        let shelves = indexedShelves
            .sorted(by: { $0.0 < $1.0 })
            .map(\.1)

        return HomeFeed(continueWatching: continueWatching, shelves: shelves)
    }
}

