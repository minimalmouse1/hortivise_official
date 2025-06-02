# HortiVige 🎥

HortiVige is a comprehensive consultation booking and video calling platform built with Flutter. This app enables users to book appointments with consultants, schedule meetings, and conduct video calls with integrated messaging and payment processing.

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Firebase Setup](#firebase-setup)
- [Development Commands](#development-commands)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Building for Production](#building-for-production)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- 📅 **Appointment Booking System** - Schedule consultations with available consultants
- 🎥 **Video Calling** - High-quality video meetings using Stream Video SDK
- 💬 **Real-time Messaging** - Chat with consultants before, during, and after meetings
- 📱 **Push Notifications** - Get notified about upcoming appointments and messages
- 💳 **Payment Integration** - Secure payment processing with Stripe
- 🔐 **User Authentication** - Firebase-based secure login and registration
- 📊 **Booking Management** - View, reschedule, and manage appointments
- 🕐 **Schedule Management** - Timezone-aware appointment scheduling
- 👥 **Consultant Profiles** - Browse and select from available consultants
- 📷 **Media Sharing** - Share images and files during consultations

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Flutter SDK** (3.27.4) - Exact version required
- **Dart SDK** (3.6.2) - Exact version required (included with Flutter)
- **Android Studio Flamingo** - Specific version required for this project
- **VS Code** with Flutter extensions (alternative to Android Studio)
- **Xcode** (for iOS development - macOS only)
- **Node.js** (v18 or higher) for Firebase Functions
- **Firebase CLI** for backend deployment
- **Git** for version control

### Version Requirements
```bash
# Check your current versions
flutter --version
dart --version

# Expected output:
# Flutter 3.27.4 • channel stable
# Dart 3.6.2 (build 3.6.2)
```

### Platform-specific Requirements

#### Windows
```powershell
# Install Chocolatey (run as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install make
choco install make

# Reboot your system after installation
```

#### macOS
```bash
# Xcode Command Line Tools (if not already installed)
xcode-select --install

# Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Linux
```bash
# Install make
sudo apt install make

# Install additional dependencies
sudo apt-get install curl git unzip xz-utils zip libglu1-mesa
```

### IDE Setup

#### Android Studio Flamingo Setup
1. Download **Android Studio Flamingo** specifically
2. Install Flutter and Dart plugins
3. Configure Android SDK (API level 21 or higher)
4. Set up Android Virtual Device (AVD) for testing
5. Configure Flutter SDK path in Android Studio

#### VS Code Setup (Alternative)
1. Install Flutter extension
2. Install Dart extension
3. Configure Flutter SDK path
4. Install additional recommended extensions:
   - Flutter Widget Snippets
   - Awesome Flutter Snippets
   - Flutter Tree

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd hortivise_official
```

### 2. Install Flutter Dependencies
```bash
# Using make command (recommended)
make get

# Or manually
flutter pub get
dart pub get
```

### 3. Generate Code (for JSON serialization)
```bash
# Using make command
make generate

# Or manually
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. iOS Setup (macOS only)
```bash
# Install CocoaPods dependencies
make podInstall

# Or manually
cd ios/
pod install
cd ..
```

## 🔥 Firebase Setup

### 1. Firebase Project Configuration
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable the following services:
   - **Authentication** (Email/Password, Google Sign-in)
   - **Firestore Database** (for storing bookings, user data, consultant profiles)
   - **Firebase Storage** (for profile pictures and shared media)
   - **Cloud Functions** (for booking logic and notifications)
   - **Firebase Messaging** (for push notifications)
   - **Analytics** (for usage tracking)
   - **Crashlytics** (for error reporting)

### 2. Android Configuration
1. Add your Android app to Firebase project
2. Download `google-services.json`
3. Place it in `android/app/` directory (already configured)

### 3. iOS Configuration
1. Add your iOS app to Firebase project
2. Download `GoogleService-Info.plist`
3. Add it to your iOS project in Xcode
4. Ensure `firebase_app_id_file.json` is properly configured

### 4. Firebase Functions Setup
```bash
# Navigate to functions directory
cd "firebase functions/functions"

# Install Node.js dependencies
npm install

# Deploy functions (requires Firebase CLI login)
firebase login
firebase deploy --only functions
```

### 5. Third-party Service Configuration
Create necessary environment files for:
- **Stripe API keys** (for payment processing)
- **Stream Video API keys** (for video calling functionality)
- **Firebase configuration**
- **Push notification certificates**

## 🛠 Development Commands

### Using Make Commands (Recommended)
```bash
# Install dependencies
make get

# Clean and reinstall dependencies
make clean

# Generate code for JSON serialization
make generate

# Watch for changes and auto-generate code
make watch

# Get dependencies and generate code
make getAndGenerate

# Install iOS pods
make podInstall

# Build APK
make apk

# Fix code formatting and apply dart fixes
make fix
```

### Manual Commands
```bash
# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Build for release
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

## 📁 Project Structure

```
hortivise_official/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/                     # Main Flutter application code
│   ├── models/             # Data models (User, Booking, Consultant)
│   ├── screens/            # UI screens (Booking, Video Call, Profile)
│   ├── services/           # API services and business logic
│   ├── providers/          # State management
│   └── widgets/            # Reusable UI components
├── assets/                  # Images, fonts, and other assets
├── firebase functions/      # Firebase Cloud Functions
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Flutter dependencies
├── makefile                # Development commands
└── README.md               # This file
```

## 📦 Key Dependencies

### Core Functionality
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Backend and authentication
- `stream_video_flutter`, `stream_video` - Video calling functionality
- `flutter_stripe` - Payment processing
- `provider` - State management
- `http` - API communication

### UI/UX Components
- `table_calendar` - Calendar for appointment scheduling
- `flutter_staggered_grid_view` - Grid layouts for consultant listings
- `flutter_svg` - SVG support for icons
- `cached_network_image` - Optimized image loading
- `super_tooltip` - Enhanced tooltips

### Utility Packages
- `timezone`, `flutter_timezone` - Timezone handling for global scheduling
- `flutter_local_notifications` - Push notifications
- `permission_handler` - Camera, microphone permissions
- `image_picker` - Profile picture and media sharing
- `shared_preferences` - Local data storage
- `intl` - Internationalization and date formatting

### Development Tools
- `build_runner`, `json_serializable` - Code generation for models
- `flutter_launcher_icons` - App icon generation
- `flutter_lints` - Code analysis and best practices

## 🏗 Building for Production

### Android APK
```bash
# Debug APK
make apk

# Release APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS (requires macOS and Xcode)
flutter build ios --release

# Build for App Store
flutter build ipa
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/booking-system`)
3. Commit your changes (`git commit -m 'Add booking confirmation feature'`)
4. Push to the branch (`git push origin feature/booking-system`)
5. Open a Pull Request

### Code Style Guidelines
- Follow Dart/Flutter style guidelines
- Use `make fix` to format code before committing
- Write meaningful commit messages
- Add tests for new booking and video call features
- Document API changes and new endpoints

## 🔧 Troubleshooting

### Common Issues

#### 1. Video Call Issues
```bash
# Check Stream Video SDK configuration
# Ensure proper API keys are set
# Verify camera and microphone permissions
```

#### 2. Payment Processing Issues
- Verify Stripe API keys (test vs production)
- Check webhook endpoints configuration
- Ensure proper SSL certificates for production

#### 3. Firebase Configuration Issues
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly placed
- Verify Firebase project configuration matches your app bundle ID
- Check Firebase CLI is logged in: `firebase login`

#### 4. Build Runner Issues
```bash
# Clean and regenerate
flutter clean
make get
make generate
```

#### 5. iOS Build Issues
```bash
# Clean iOS build
cd ios/
rm -rf Pods/ Podfile.lock
pod install
cd ..
flutter clean
flutter build ios
```

#### 6. Notification Issues
- Test on physical devices (notifications don't work on simulators)
- Verify FCM configuration
- Check notification permissions

### Getting Help

- Check [Flutter Documentation](https://docs.flutter.dev/)
- Review [Firebase Documentation](https://firebase.google.com/docs)
- Check [Stream Video Documentation](https://getstream.io/video/docs/)
- Review [Stripe Flutter Documentation](https://stripe.com/docs/payments/accept-a-payment?platform=flutter)
- Search existing issues in the repository
- Create a new issue with detailed error logs

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For technical support or questions about the consultation booking platform, please contact the development team or create an issue in the repository.

---

**Connect, Consult, Collaborate! 🎥💬**
