#!/usr/bin/env bash
# TheaterBD APK Build Script
set -e
echo "==============================================="
echo "   TheaterBD Android APK Build Script"
echo "==============================================="
cd "$(dirname "$0")"
chmod +x gradlew
echo "Cleaning and building Release & Debug APKs..."
./gradlew clean assembleDebug assembleRelease --no-daemon --stacktrace
echo "-----------------------------------------------"
echo "Build successful! APKs generated:"
ls -la app/build/outputs/apk/debug/*.apk 2>/dev/null || true
ls -la app/build/outputs/apk/release/*.apk 2>/dev/null || true
echo "==============================================="
