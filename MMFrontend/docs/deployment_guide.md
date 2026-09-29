# Mandi Minutes - Android Deployment Guide

This guide outlines the steps required to prepare and deploy the Mandi Minutes Flutter application to the Google Play Store.

## 1. App Configuration
- **App Name**: The app is configured with the label "Mandi Minutes" in `android/app/src/main/AndroidManifest.xml`.
- **Package Name**: Found in `android/app/build.gradle`. Ensure this matches your registered Google Play Console package name (e.g., `com.mm.frontend.mandi_minutes`).
- **Version**: Managed via `pubspec.yaml` (e.g., `version: 1.0.0+1`). Before every new release, increment the `+1` (build number).

## 2. API Environment Setup
Before building the production APK/AppBundle, update the base URL in `lib/core/constants/api_constants.dart` to point to the production backend:
```dart
static String get baseUrl => prodBaseUrl; // https://api.mandiminutes.com
```

## 3. App Icons
The launcher icons have been generated using `flutter_launcher_icons`. 
If you need to update the icon in the future:
1. Replace `assets/images/app_icon.png` with a 1024x1024 PNG.
2. Run: `flutter pub run flutter_launcher_icons`

## 4. Keystore Generation
To upload to the Play Store, the app must be signed with a release keystore.
Run the following in the terminal (Windows):
```powershell
keytool -genkey -v -keystore c:\path\to\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create a file named `key.properties` in the `android/` folder:
```properties
storePassword=<password_from_previous_step>
keyPassword=<password_from_previous_step>
keyAlias=upload
storeFile=c:/path/to/upload-keystore.jks
```

## 5. Building the App
To build the production-ready Android App Bundle (AAB):
```powershell
flutter build appbundle --release
```
The resulting file will be at `build/app/outputs/bundle/release/app-release.aab`.

## 6. Play Store Upload
1. Go to the [Google Play Console](https://play.google.com/console).
2. Create a new app entry.
3. Complete the content rating, privacy policy, and store listing steps.
4. Go to **Testing > Internal Testing** or **Production**.
5. Upload the generated `app-release.aab` file.
6. Submit for review!
