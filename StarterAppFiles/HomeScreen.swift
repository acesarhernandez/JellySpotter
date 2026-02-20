import JellySpotterCore
import SwiftUI

struct HomeScreen: View {
    let config: JellyfinConfig
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    continueWatchingSection
                    ForEach(viewModel.shelves) { shelf in
                        ShelfSection(title: shelf.title, items: shelf.items, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 64)
                .padding(.vertical, 40)
            }
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading your library...")
                        .tint(Theme.accent)
                }
            }
            .alert("Could not load Jellyfin", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task(id: config) {
            await viewModel.load(config: config)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("JellySpotter")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Text("Spot your next watch.")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var continueWatchingSection: some View {
        ShelfSection(title: "Continue Watching", items: viewModel.continueWatching, viewModel: viewModel)
    }
}

private struct ShelfSection: View {
    let title: String
    let items: [MediaItem]
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)

                ScrollView(.horizontal) {
                    HStack(spacing: 24) {
                        ForEach(items) { item in
                            NavigationLink {
                                DetailsView(item: item, imageURL: viewModel.backdropURL(for: item))
                            } label: {
                                MediaCardView(item: item, imageURL: viewModel.posterURL(for: item))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

