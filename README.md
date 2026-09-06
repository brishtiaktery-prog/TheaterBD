# TheaterBD — Production Android Web Viewer

Production-ready Android application for the **TheaterBD** streaming and media platform (`http://198.18.18.18/`).

Designed for:
1. **Android Smartphones** (Portrait & Landscape, Pull-to-refresh)
2. **Android Tablets** (Responsive tablet viewport, Hardware acceleration)
3. **Android TV & Google TV** (Full D-Pad remote navigation, Leanback launcher, 16:9 banner)
4. **Android TV Boxes** (No touchscreen required, remote-first key handling)

---

## Key Architecture & Features

- **Package Name**: `net.theaterbd.app`
- **Application Label**: `TheaterBD`
- **Target URL**: `http://198.18.18.18/`
- **Compile SDK**: 34 (Android 14) | **Target SDK**: 34 | **Min SDK**: 21 (Lollipop 5.0+)
- **HTTP Cleartext Security**: Strict `network_security_config.xml` permitting cleartext HTTP traffic **only** for `198.18.18.18`, while enforcing HTTPS for all external domains.
- **HTML5 Video & Fullscreen**: Custom `WebChromeClient` with custom view attachment, automatic landscape lock during fullscreen, sticky immersive flags, and `FLAG_KEEP_SCREEN_ON`.
- **Android TV Remote & D-Pad**: Focusable WebView with directional key navigation (`DPAD_UP`, `DPAD_DOWN`, `DPAD_LEFT`, `DPAD_RIGHT`, `DPAD_CENTER`, `ENTER`) and TV banner (`320x180` / `640x360`).
- **Touchscreen Optional**: Configured `<uses-feature android:name="android.hardware.touchscreen" android:required="false" />` so it installs on TV devices from Google Play.
- **Intelligent Back Navigation**:
  1. If playing fullscreen video → exits fullscreen.
  2. If WebView history exists → goes back.
  3. Otherwise → displays dark-themed "Exit TheaterBD?" confirmation dialog.
- **Offline & Server Error Screen**: If `http://198.18.18.18/` is unreachable or down, a dark-themed error screen is shown with **[Retry]** and **[Exit]** buttons (auto-focused for TV remotes).
- **Download & File Chooser**: Integrated Android `DownloadManager` and `ActivityResultLauncher` for file uploads.
- **State Preservation**: Activity lifecycle preserves WebView scroll, history, and video state across rotations.

---

## Project Structure

```
android/
├── app/
│   ├── build.gradle.kts             # App-level build config (SDK 34, Proguard, AAB)
│   ├── proguard-rules.pro           # Proguard optimization rules
│   └── src/main/
│       ├── AndroidManifest.xml      # Permissions, TV Leanback, activities
│       ├── java/net/theaterbd/app/
│       │   ├── MainActivity.kt      # Main WebView, D-pad, Back navigation, Video
│       │   ├── SplashActivity.kt    # Android 12+ Splash screen launcher
│       │   ├── TheaterChromeClient.kt # Fullscreen video & progress management
│       │   ├── TheaterWebViewClient.kt # URL routing, error handling & cookies
│       │   └── DownloadHelper.kt    # System DownloadManager integration
│       └── res/
│           ├── drawable/            # TV banners, custom buttons, logo drawables
│           ├── layout/              # activity_main, activity_splash, error view
│           ├── mipmap-*/            # Launcher icons (mdpi to xxxhdpi) + round
│           ├── values/              # colors.xml, strings.xml, themes.xml
│           └── xml/                 # network_security_config.xml
├── gradle/wrapper/                  # Gradle wrapper 8.4 configuration
├── build.gradle.kts                 # Root Gradle build script
├── settings.gradle.kts              # Project settings & repositories
├── gradle.properties                # JVM & AndroidX settings
├── gradlew                          # Linux/macOS build script
├── gradlew.bat                      # Windows build script
└── README.md                        # Documentation
```

---

## How to Open in Android Studio

1. Launch **Android Studio** (Hedgehog, Iguana, Jellyfish, or newer).
2. Select **Open** and choose the `android/` directory.
3. Allow Gradle to sync dependencies (Google Maven & Maven Central).
4. Connect an Android phone, tablet, or Android TV device (or start an emulator).
5. Click **Run 'app'** (`Shift + F10`).

---

## Command Line Build & Testing

### 1. Build Debug APK
```bash
./gradlew assembleDebug
# APK located at: app/build/outputs/apk/debug/app-debug.apk
```

### 2. Build Release APK
```bash
./gradlew assembleRelease
# APK located at: app/build/outputs/apk/release/app-release.apk
```

### 3. Build Google Play Store App Bundle (AAB)
```bash
./gradlew bundleRelease
# AAB located at: app/build/outputs/bundle/release/app-release.aab
```

### 4. Install onto Connected Phone or Android TV via ADB
```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

### 5. Launch Directly on Android TV
```bash
adb shell monkey -p net.theaterbd.app -c android.intent.category.LEANBACK_LAUNCHER 1
```

---

## Publishing to Google Play Store

1. In `app/build.gradle.kts`, configure your release signing keystore:
   ```kotlin
   signingConfigs {
       create("release") {
           storeFile = file("path/to/my-release-key.jks")
           storePassword = System.getenv("KEYSTORE_PASSWORD")
           keyAlias = System.getenv("KEY_ALIAS")
           keyPassword = System.getenv("KEY_PASSWORD")
       }
   }
   ```
2. Run `./gradlew bundleRelease`.
3. Upload `app-release.aab` to Google Play Console.
