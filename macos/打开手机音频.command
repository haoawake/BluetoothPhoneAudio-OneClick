#!/bin/zsh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
osascript "$SCRIPT_DIR/PhoneAudioBridge.applescript"
