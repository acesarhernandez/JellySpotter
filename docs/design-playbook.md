# JellySpotter Design Playbook (Plex-Like, Not Plex Clone)

Use this to design with intent, not random tweaks.

## 1. Product Pillars

- Fast scan: users should spot something in under 10 seconds.
- Calm browsing: avoid noisy screens and tiny metadata.
- One-click confidence: title art + short context must be enough to start.

If a UI change does not improve one of those, reject it.

## 2. Home Layout Rules

- Hero header: product identity + short tagline.
- First shelf must be `Continue Watching`.
- Keep 3-5 shelves max on initial load.
- Cards need clear poster dominance and minimal text.
- Focus state must be obvious from 8-10 feet away.

## 3. Visual System

- Background: layered gradient, not flat black.
- Accent color: one clear accent only.
- Typography: rounded/system works well on TV at distance.
- Poster ratio: 2:3.
- Spacing: generous horizontal spacing for D-pad navigation.

## 4. Motion Rules

- Focus: scale up to 1.04-1.07 + stronger shadow.
- Navigation: use default tvOS transitions first.
- Keep animation duration around 0.15-0.22 seconds.

## 5. First 3 Iterations

1. **Iteration A (Functionality):** confirm shelves load fast and navigation is stable.
2. **Iteration B (Readability):** tune font sizes and spacing from couch distance.
3. **Iteration C (Personality):** adjust colors, title styling, and details layout.

## 6. UX Checklist Before TestFlight

- Cold launch to home under 2 seconds on local network.
- No dead-end screens.
- D-pad navigation always predictable.
- Back button behavior consistent everywhere.
- Error screen explains exactly what to fix (URL, API key, user id).

