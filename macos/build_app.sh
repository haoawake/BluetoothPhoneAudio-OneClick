#!/bin/zsh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/macos"
rm -rf "$OUT"
mkdir -p "$OUT"
osacompile -o "$OUT/BluetoothPhoneAudio-OneClick.app" "$ROOT/macos/PhoneAudioBridge.applescript"
/usr/bin/ditto -c -k --keepParent "$OUT/BluetoothPhoneAudio-OneClick.app" "$ROOT/dist/BluetoothPhoneAudio-OneClick-mac-universal.zip"
echo "Created $ROOT/dist/BluetoothPhoneAudio-OneClick-mac-universal.zip"
