# GitHub Actions APK Build Setup

## 📋 What Was Done

### Cleaned Up Files
✅ Removed old APK file  
✅ Removed .DS_Store files  
✅ Removed extra documentation files  
✅ Kept only essential: README.md, pubspec.yaml, lib/, assets/  

### Created Files
✅ `.gitignore` - Flutter project ignore rules  
✅ `.github/workflows/build-apk.yml` - GitHub Actions workflow  
✅ `android/` directory - Complete Android configuration  

---

## 🚀 Setup Steps

### 1. Initialize Git Repository (if not already done)

```bash
git init
git add .
git commit -m "Initial commit - Banana Hisab Flutter app"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `banana-hisab`)
3. **Don't** initialize with README (we already have one)

### 3. Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/banana-hisab.git
git branch -M main
git push -u origin main
```

### 4. GitHub Actions Will Automatically Run

Once pushed, GitHub Actions will:
- ✅ Detect the push to `main` branch
- ✅ Setup Java 17
- ✅ Setup Flutter 3.16.0
- ✅ Run `flutter pub get`
- ✅ Build release APK
- ✅ Upload APK as artifact

---

## 📥 Download APK from GitHub Actions

### After Push:

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Click on the latest workflow run
4. Scroll down to **Artifacts** section
5. Download `banana-hisab-apk`
6. Extract the ZIP to get `app-release.apk`

---

## 🔧 Workflow Triggers

The workflow runs on:
- ✅ Push to `main` or `master` branch
- ✅ Pull requests to `main` or `master`
- ✅ Manual trigger (workflow_dispatch)

### Manual Trigger:
1. Go to **Actions** tab
2. Select **Build APK** workflow
3. Click **Run workflow** button
4. Select branch and click **Run workflow**

---

## 📝 Workflow Configuration

File: `.github/workflows/build-apk.yml`

```yaml
- Flutter Version: 3.16.0
- Java Version: 17
- Build Type: Release APK
- Artifact Name: banana-hisab-apk
```

---

## 🎯 Next Steps After Setup

### Option 1: Basic Usage
```bash
# Make changes to code
git add .
git commit -m "Your changes"
git push

# APK will be built automatically
# Download from Actions tab
```

### Option 2: Add Release Tags
```bash
# Create a release
git tag v1.0.0
git push origin v1.0.0

# Modify workflow to create GitHub Release on tags
```

### Option 3: Add Signing (for Play Store)

1. Generate keystore:
```bash
keytool -genkey -v -keystore banana-hisab.keystore -alias banana-hisab -keyalg RSA -keysize 2048 -validity 10000
```

2. Add to GitHub Secrets:
   - `KEYSTORE_BASE64` (base64 encoded keystore)
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`

3. Update workflow to use signing

---

## 🔐 GitHub Secrets (Optional - for Signed APK)

Go to: Repository → Settings → Secrets and variables → Actions

Add these secrets:
- `KEYSTORE_BASE64`: Base64 encoded keystore file
- `KEYSTORE_PASSWORD`: Keystore password
- `KEY_ALIAS`: Key alias
- `KEY_PASSWORD`: Key password

---

## 📱 Testing the APK

After downloading:

1. Transfer APK to Android device
2. Enable "Install from Unknown Sources"
3. Install the APK
4. Test all features

---

## 🐛 Troubleshooting

### Build Fails?
- Check Actions logs for errors
- Ensure `pubspec.yaml` has correct dependencies
- Verify Flutter version compatibility

### APK Not Generated?
- Check if workflow completed successfully
- Look for red X marks in Actions tab
- Review build logs

### Can't Download Artifact?
- Artifacts expire after 90 days (default)
- Must be logged into GitHub
- Check if workflow completed

---

## 📊 Build Status Badge (Optional)

Add to README.md:

```markdown
![Build APK](https://github.com/YOUR_USERNAME/banana-hisab/workflows/Build%20APK/badge.svg)
```

---

## ✅ Verification Checklist

- [ ] Git repository initialized
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] GitHub Actions workflow triggered
- [ ] Workflow completed successfully (green checkmark)
- [ ] APK artifact available for download
- [ ] APK downloaded and tested on device

---

## 🎉 You're Done!

Your Flutter app now builds automatically on every push to GitHub!

**Next push will trigger a new build automatically.**
