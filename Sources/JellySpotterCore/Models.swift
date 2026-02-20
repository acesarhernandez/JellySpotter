import Foundation

public struct MediaLibrary: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let collectionType: String?

    public init(id: String, name: String, collectionType: String?) {
        self.id = id
        self.name = name
        self.collectionType = collectionType
    }
}

public struct MediaItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let overview: String?
    public let year: Int?
    public let mediaType: String?
    public let runtimeTicks: Int64?
    public let playedPercentage: Double?
    public let primaryImageTag: String?
    public let backdropImageTag: String?

    public init(
        id: String,
        title: String,
        overview: String?,
        year: Int?,
        mediaType: String?,
        runtimeTicks: Int64?,
        playedPercentage: Double?,
        primaryImageTag: String?,
        backdropImageTag: String?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.year = year
        self.mediaType = mediaType
        self.runtimeTicks = runtimeTicks
        self.playedPercentage = playedPercentage
        self.primaryImageTag = primaryImageTag
        self.backdropImageTag = backdropImageTag
    }
}

public struct HomeShelf: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let items: [MediaItem]

    public init(id: String, title: String, items: [MediaItem]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

public struct HomeFeed: Sendable {
    public let continueWatching: [MediaItem]
    public let shelves: [HomeShelf]

    public init(continueWatching: [MediaItem], shelves: [HomeShelf]) {
        self.continueWatching = continueWatching
        self.shelves = shelves
    }
}

