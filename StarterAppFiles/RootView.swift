import JellySpotterCore
import SwiftUI

struct RootView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("apiKey") private var apiKey = ""
    @AppStorage("userID") private var userID = ""

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            if let config = try? JellyfinConfig(baseURL: serverURL, apiKey: apiKey, userID: userID) {
                HomeScreen(config: config)
            } else {
                SetupView(serverURL: $serverURL, apiKey: $apiKey, userID: $userID)
            }
        }
    }
}

private struct SetupView: View {
    @Binding var serverURL: String
    @Binding var apiKey: String
    @Binding var userID: String

    var body: some View {
        Form {
            Section("JellySpotter Setup") {
                TextField("Server URL (http://192.168.1.100:8096)", text: $serverURL)
                TextField("API Key", text: $apiKey)
                TextField("User ID", text: $userID)
            }
            Section {
                Text("Fill all fields to load your home screen.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

