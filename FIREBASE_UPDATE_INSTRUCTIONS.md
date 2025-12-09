# Firebase Package Name Update Instructions

## Step 1: Update Firebase Console

### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **mcq-mentor-6f840**
3. Click the gear icon ⚙️ → **Project settings**
4. Scroll to **Your apps** section
5. Click **Add app** → Select **Android** icon
6. Enter package name: `com.mcqmentor.app`
7. Register app (you can skip App nickname and Debug signing certificate SHA-1 for now)
8. Download the new `google-services.json` file
9. Replace the file at: `android/app/google-services.json`

### For iOS:
1. In the same **Your apps** section
2. Click **Add app** → Select **iOS** icon  
3. Enter bundle ID: `com.mcqmentor.app`
4. Register app (you can skip App nickname for now)
5. Download the new `GoogleService-Info.plist` file
6. Replace the file at: `ios/Runner/GoogleService-Info.plist`

### For macOS (if needed):
1. In the same **Your apps** section
2. Click **Add app** → Select **iOS** icon (macOS uses iOS config)
3. Enter bundle ID: `com.mcqmentor.app`
4. Download the new `GoogleService-Info.plist` file
5. Replace the file at: `macos/Runner/GoogleService-Info.plist`

## Step 2: Regenerate Firebase Options (Recommended)

After updating Firebase Console, regenerate the Flutter Firebase configuration:

```bash
# Install FlutterFire CLI if not already installed
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

This will:
- Automatically detect your Firebase apps
- Update `lib/firebase_options.dart` with correct configuration
- Ensure all platforms are properly configured

## Alternative: Manual Update

If you prefer to manually update, after downloading the new config files from Firebase Console, you'll need to update the App IDs in `lib/firebase_options.dart` to match the new apps.

## Important Notes:

- The old app with `com.example.mcq_mentor` can remain in Firebase (it won't cause issues)
- Make sure to use the **new** App IDs from the newly registered apps
- The certificate hash in `google-services.json` should match your upload keystore
- After updating, rebuild your app: `flutter clean && flutter build appbundle`

