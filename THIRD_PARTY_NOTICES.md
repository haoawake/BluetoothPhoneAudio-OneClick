# Third-party notices

## AudioPlaybackConnector

Windows uses the open-source project **Dearkoma/AudioPlaybackConnector** as the A2DP Sink runtime.

- Project: https://github.com/Dearkoma/AudioPlaybackConnector
- Purpose: Manage Windows 10 2004+ / Windows 11 Bluetooth A2DP Sink connections through `AudioPlaybackConnection`.
- License: MIT

This repository does not silently modify the downloaded executable. `windows/Bootstrap.ps1` downloads the published release asset and verifies the GitHub-provided SHA-256 digest when available before launch.
