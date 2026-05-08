# 🚀 Quick Start Guide

## Step-by-Step Setup (5 minutes)

### 1️⃣ Initialize Git & Push to GitHub

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Banana Hisab Flutter app"

# Create repository on GitHub (https://github.com/new)
# Then connect and push:
git remote add origin https://github.com/YOUR_USERNAME/banana-hisab.git
git branch -M main
git push -u origin main
```

### 2️⃣ Wait for GitHub Actions

- Go to your repository on GitHub
- Click **Actions** tab
- Watch the build progress (takes ~3-5 minutes)
- ✅ Green checkmark = Success!

### 3️⃣ Download APK

- In the completed workflow run
- Scroll to **Artifacts** section
- Download `banana-hisab-apk.zip`
- Extract to get `app-release.apk`

### 4️⃣ Install on Android Device

- Transfer APK to phone
- Enable "Install from Unknown Sources"
- Install and test!

---

## 📁 Project Structure

```
banana-hisab/
├── .github/workflows/
│   └── build-apk.yml          # GitHub Actions workflow
├── android/                    # Android configuration
├── assets/
│   └── logo.png               # App logo (add your own)
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   ├── providers/             # State management
│   ├── screens/               # UI screens
│   ├── services/              # Business logic
│   ├── utils/                 # Utilities
│   └── widgets/               # Reusable widgets
├── .gitignore                 # Git ignore rules
├── pubspec.yaml               # Dependencies
├── README.md                  # Project overview
└── GITHUB_ACTIONS_SETUP.md    # Detailed setup guide
```

---

## 🔄 Making Changes

```bash
# 1. Make your code changes
# 2. Commit and push
git add .
git commit -m "Your changes"
git push

# 3. GitHub Actions builds automatically
# 4. Download new APK from Actions tab
```

---

## ✅ What's Configured

- ✅ Flutter 3.16.0
- ✅ Java 17
- ✅ Android API 21-34
- ✅ Release APK build
- ✅ Automatic artifact upload
- ✅ Triggers on push/PR/manual

---

## 📞 Need Help?

See detailed guides:
- [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) - Complete setup instructions
- [README.md](README.md) - Project documentation

**Developer**: Ganesh Patil  
**Phone**: +91 9823809555  
**Email**: ganeshpatil5810@gmail.com
