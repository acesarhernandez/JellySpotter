import SwiftUI

enum Theme {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.02, green: 0.05, blue: 0.11),
            Color(red: 0.04, green: 0.10, blue: 0.16),
            Color(red: 0.01, green: 0.02, blue: 0.04)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardBackground = Color.white.opacity(0.08)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let accent = Color(red: 0.24, green: 0.83, blue: 0.76)
}

