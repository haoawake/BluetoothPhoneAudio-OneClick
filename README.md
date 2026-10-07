# BluetoothPhoneAudio-OneClick

Cross-platform helper for playing phone audio through a computer.

- Windows 10 2004+ / Windows 11: Bluetooth A2DP Sink via the Windows `AudioPlaybackConnection` stack.
- macOS 12+: Apple AirPlay Receiver for audio from iPhone/iPad/other AirPlay senders.

The macOS path intentionally does **not** claim to provide Bluetooth A2DP Sink: macOS does not expose an equivalent public sink API to ordinary apps.

Chinese documentation: [README.zh-CN.md](README.zh-CN.md)

## License

MIT for this repository's scripts. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the Windows runtime dependency.
