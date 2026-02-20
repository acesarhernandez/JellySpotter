import JellySpotterCore
import SwiftUI

struct DetailsView: View {
    let item: MediaItem
    let imageURL: URL?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Theme.background
                }
            }
            .ignoresSafeArea()
            .overlay {
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.system(size: 62, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(item.overview ?? "No summary yet.")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.92))
                    .frame(maxWidth: 1000, alignment: .leading)
            }
            .padding(64)
        }
    }
}

