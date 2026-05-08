# Banana Hisab - Flutter App

A complete offline-first banana trade accounting application for the Indian agricultural sector.

## Features

- **Calculator**: Real-time calculation with Patti, Danda, Commission, and Majuri
- **History**: Search and filter transactions by date
- **Parties**: Manage trading parties with auto-creation
- **Profit Calculator**: Calculate profit/loss between buying and selling rates
- **PDF Generation**: Share receipts as PDF or text via WhatsApp/SMS
- **Offline-First**: All data stored locally using SQLite
- **Indian Number Formatting**: Currency and number-to-words in Indian format

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Add Logo Asset (Optional)

Place your app logo at `assets/logo.png` (recommended size: 512x512px)

### 3. Run the App

```bash
flutter run
```

### 4. Build APK

#### Option A: Local Build
```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

#### Option B: GitHub Actions (Recommended)
1. Push code to GitHub
2. GitHub Actions automatically builds APK
3. Download from Actions tab → Artifacts

See [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) for detailed instructions.

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── transaction.dart
│   ├── party.dart
│   └── settings.dart
├── providers/                   # State management
│   ├── calculator_provider.dart
│   ├── transaction_provider.dart
│   ├── party_provider.dart
│   └── settings_provider.dart
├── screens/                     # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── history_screen.dart
│   ├── parties_screen.dart
│   ├── profit_screen.dart
│   └── more_screen.dart
├── widgets/                     # Reusable widgets
│   ├── custom_bottom_nav.dart
│   ├── input_card.dart
│   ├── result_card.dart
│   ├── transaction_tile.dart
│   └── party_tile.dart
├── services/                    # Business logic
│   ├── database_service.dart
│   ├── calculation_service.dart
│   └── pdf_service.dart
└── utils/                       # Utilities
    ├── constants.dart
    ├── number_utils.dart
    └── date_utils.dart
```

## Technical Details

- **Flutter SDK**: 3.16+
- **State Management**: Provider
- **Database**: SQLite (sqflite)
- **PDF Generation**: pdf + printing packages
- **Minimum Android**: API 21 (Android 5.0)
- **Target APK Size**: < 10MB

## Developer

**Ganesh Patil**
- Phone: +91 9823809555
- Email: ganeshpatil5810@gmail.com

## License

Proprietary - All rights reserved
