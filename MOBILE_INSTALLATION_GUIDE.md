# Archer Match Up - Mobile Installation Guide

## 📱 APK Files Available

Your app has been successfully built! You now have two APK files available:

### **Recommended: Release APK (for daily use)**
- **File**: `app-release.apk` (46.0MB)
- **Location**: `e:\flutter-dev\archer-match-up\build\app\outputs\flutter-apk\app-release.apk`
- **Best for**: Daily use, better performance, smaller size

### **Debug APK (for development)**
- **File**: `app-debug.apk`
- **Location**: `e:\flutter-dev\archer-match-up\build\app\outputs\flutter-apk\app-debug.apk`
- **Best for**: Development and debugging

---

## 🚀 Installation Methods

### Method 1: USB Cable Transfer (Recommended)

#### Step 1: Enable Developer Options
1. On your Android phone, go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times to enable Developer Options
3. Go back to **Settings** → **Developer Options**
4. Enable **USB Debugging**

#### Step 2: Transfer APK
1. Connect your phone to your computer via USB cable
2. Copy `app-release.apk` from:
   ```
   e:\flutter-dev\archer-match-up\build\app\outputs\flutter-apk\app-release.apk
   ```
3. Paste it to your phone's **Downloads** folder

#### Step 3: Install APK
1. On your phone, open **File Manager** → **Downloads**
2. Tap on `app-release.apk`
3. Allow **Install from Unknown Sources** if prompted
4. Tap **Install**
5. Once installed, tap **Open** to launch the app

---

### Method 2: Email/Cloud Transfer

#### Step 1: Upload APK
1. Upload `app-release.apk` to Google Drive, Dropbox, or email it to yourself

#### Step 2: Download on Phone
1. Download the APK file on your Android phone
2. Open it from Downloads folder
3. Follow installation prompts

---

### Method 3: Direct Flutter Install (if phone is connected)

#### Prerequisites
- Phone connected via USB with USB Debugging enabled
- Phone recognized by your computer

#### Install Command
```bash
cd "e:\flutter-dev\archer-match-up"
flutter install
```

---

## ⚙️ Important Settings

### Allow Installation from Unknown Sources
Since this isn't from Google Play Store, you'll need to:

1. **Android 8.0+**: When prompted during installation, tap **Settings** → Enable **Allow from this source**
2. **Older Android**: Go to **Settings** → **Security** → Enable **Unknown Sources**

### Permissions Required
The app will request these permissions:
- ✅ **Storage**: To save match data locally
- ✅ **Internet**: For future cloud sync features (optional)

---

## 📋 Installation Verification

### After Installation
1. **App Icon**: Look for "Archer Match Up" on your home screen
2. **Launch Test**: Open the app and try creating a test match
3. **Functionality Check**: 
   - Create a match
   - Register archers
   - Start scoring
   - Navigate between screens

### Expected Behavior
- ✅ App launches without crashes
- ✅ Can create and manage matches
- ✅ Single-device scoring interface works
- ✅ Data persists when closing/reopening app
- ✅ Navigation maintains match status

---

## 🔧 Troubleshooting

### Installation Issues

#### "App not installed" error
- **Solution**: Enable "Install from Unknown Sources"
- **Alternative**: Use `flutter install` command

#### "Parse Error" 
- **Cause**: Corrupted APK download
- **Solution**: Re-download or re-transfer the APK file

#### "Insufficient Storage"
- **Requirement**: ~50MB free space
- **Solution**: Clear some storage and try again

### Runtime Issues

#### App crashes on startup
- **Check**: Android version (requires Android 5.0+)
- **Solution**: Try the debug APK instead

#### Features not working
- **Storage Permission**: Ensure storage permission is granted
- **Restart**: Close and reopen the app

---

## 📱 Device Requirements

### Minimum Requirements
- **Android**: 5.0 (API level 21) or higher
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 100MB free space
- **Internet**: Not required (offline-first app)

### Optimal Performance
- **Android**: 8.0+ for best experience
- **RAM**: 4GB+ for smooth operation
- **Storage**: 500MB+ for future data growth

---

## 🎯 App Features Available

Once installed, you can:

### ✅ **Match Management**
- Create archery matches
- Set match parameters (ends, arrows, rounds)
- Generate match codes for sharing

### ✅ **Archer Registration**
- Register multiple archers
- Approve/reject registrations
- Manage participant lists

### ✅ **Single-Device Scoring**
- Pass device between archers
- Individual scoring interface
- Real-time progress tracking
- Score validation and storage

### ✅ **Offline Functionality**
- Works completely offline
- Local data storage via Hive
- No internet required for basic features

### ✅ **Progress Tracking**
- Live leaderboards
- Individual scorecards
- Round-by-round progress
- Match statistics

---

## 🔄 Updates

### Future Updates
To update the app:
1. Build new APK with: `flutter build apk --release`
2. Transfer and install new APK (will update existing app)
3. Your data will be preserved

### Version Information
- **Current Version**: Development Build
- **Build Date**: September 30, 2025
- **Flutter Version**: 3.35.4

---

## 📞 Support

### Issues or Questions
- **Development Documentation**: See `DEVELOPMENT_HISTORY.md`
- **Feature Requests**: Can be implemented in future builds
- **Bug Reports**: Check logs and re-build if necessary

### Quick Commands for Rebuilding
```bash
# Navigate to project
cd "e:\flutter-dev\archer-match-up"

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build new release APK
flutter build apk --release
```

---

*Enjoy using Archer Match Up for your archery scoring needs! The app is designed for offline use and perfect for tournament or practice session management.*