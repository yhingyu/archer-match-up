# Quick Installation Steps for Archer Match Up

## 📱 USB Transfer Method (Step-by-Step)

### **On Your Android Phone:**

#### 1. Enable Developer Options
- Go to **Settings** → **About Phone** (or **About Device**)
- Find **Build Number** and tap it **7 times**
- You'll see "You are now a developer!" message

#### 2. Enable USB Debugging
- Go back to **Settings** → **Developer Options**
- Turn on **USB Debugging**
- Also enable **Install via USB** (if available)

#### 3. Allow Unknown Sources
- Go to **Settings** → **Security** (or **Privacy**)
- Enable **Unknown Sources** or **Install unknown apps**

### **On Your Computer:**

#### 4. Connect Phone
- Connect your Android phone to computer via USB cable
- On phone, select **File Transfer (MTP)** when prompted
- Allow USB debugging when popup appears

#### 5. Copy APK File
📁 **Copy this file:**
```
FROM: e:\flutter-dev\archer-match-up\build\app\outputs\flutter-apk\app-release.apk
TO: Your Phone's Downloads folder
```

### **Back on Your Phone:**

#### 6. Install APK
- Open **File Manager** app
- Navigate to **Downloads** folder
- Tap on **app-release.apk**
- Tap **Install** when prompted
- If blocked, tap **Settings** → Enable **Allow from this source**
- Tap **Install** again

#### 7. Launch App
- Once installed, tap **Open** or find "Archer Match Up" on home screen
- Grant any permissions requested (Storage access)

---

## 🎯 **Quick Test:**
1. Create a test match
2. Register a few archers
3. Start the match
4. Try the scoring interface

**File Size:** 46.0MB
**Install Time:** ~2-3 minutes
**Works Offline:** ✅ Yes, no internet needed

---

## 🆘 **Need Help?**
If any step doesn't work, try the alternative flutter install command:
```
flutter install
```
(Run this in PowerShell with phone connected)