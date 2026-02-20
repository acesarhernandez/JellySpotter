import JellySpotterCore
import SwiftUI

struct MediaCardView: View {
    let item: MediaItem
    let imageURL: URL?
    @Environment(\.isFocused) private var isFocused

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Theme.cardBackground)
                    .frame(width: 260, height: 380)

                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Theme.cardBackground)
                            Image(systemName: "film")
                                .font(.system(size: 42))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                .frame(width: 260, height: 380)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            Text(item.title)
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)

            Text(item.year.map(String.init) ?? "Unknown year")
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(width: 260, alignment: .leading)
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(color: .black.opacity(isFocused ? 0.5 : 0.15), radius: isFocused ? 18 : 6, y: isFocused ? 12 : 4)
        .animation(.easeOut(duration: 0.18), value: isFocused)
    }
}

