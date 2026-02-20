# Jellyfin Setup Notes

## Get an API Key

1. Open Jellyfin web dashboard as admin.
2. Go to `Dashboard > API Keys`.
3. Create a new key, for example `JellySpotter-tvOS`.
4. Copy the key into your app setup screen.

## Get User ID

Option A (easiest):
1. Open Jellyfin admin dashboard.
2. Go to `Users`.
3. Click the user profile you want the app to use.
4. Check the URL in browser and copy the id value.

Option B (API):
1. Call: `/Users/Public`.
2. Find your username and copy its `Id`.

## URL Format

- Local network example: `http://192.168.1.100:8096`
- Do not include extra path segments.
- Do not include trailing slash.

