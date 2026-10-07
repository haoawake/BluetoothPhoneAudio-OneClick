#!/bin/zsh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/macos"
rm -rf "$OUT"
mkdir -p "$OUT"
osacompile -o "$OUT/AudioBridge.app" "$ROOT/macos/PhoneAudioBridge.applescript"
/usr/bin/ditto -c -k --keepParent "$OUT/AudioBridge.app" "$ROOT/dist/AudioBridge-mac-universal.zip"
echo "Created $ROOT/dist/AudioBridge-mac-universal.zip"
