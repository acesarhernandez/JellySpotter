# JellySpotter

JellySpotter is a custom Apple TV client for Jellyfin, built with a Plex-inspired browsing style and room to tune the interface over time.

The goal is simple: keep the media server open and self-hosted, but make the living-room experience feel premium.

## Intention

- Build a TV-first interface that is fast to scan and easy to navigate with a remote.
- Keep the visual quality high without copying another product one-to-one.
- Keep the app flexible so layout, style, and behavior can evolve quickly.

## Current Scope

The repo currently includes the core pieces for a first working version:

- Jellyfin API client and models (`JellySpotterCore`).
- Home feed loading for Continue Watching + library shelves.
- Starter SwiftUI tvOS screens for browsing and details.
- Docs for design direction and Jellyfin connection setup.

## Project Layout

- `Sources/JellySpotterCore/`  
  Networking, models, and home feed service.
- `StarterAppFiles/`  
  SwiftUI app shell and starter screens for tvOS.
- `docs/design-playbook.md`  
  Visual and UX direction for iterative design work.
- `docs/jellyfin-setup.md`  
  Jellyfin API key, user ID, and connection notes.

## Product Direction

Near-term roadmap:

- Stable browsing experience on Apple TV.
- Playback and resume flow.
- Better metadata and details presentation.
- Search and discovery improvements.
- TestFlight distribution for real-device feedback.

## Notes

JellySpotter is intended for personal/family media access on a self-hosted Jellyfin server.  
If exposed outside a local network, secure it with HTTPS and strong auth.
