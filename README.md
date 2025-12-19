# Tripora - AI-Powered Travel Planning App

![Tripora Logo](assets/logo/tripora.JPG)

**Tripora** is a comprehensive Flutter-based mobile application designed to revolutionize travel planning with intelligent AI assistance, collaborative features, and seamless integration with travel booking services.

## 📱 Overview

Tripora is your all-in-one travel companion that helps you plan, organize, and execute perfect trips. From flight booking to itinerary creation, expense tracking to cultural preparation, Tripora leverages AI agents and cloud services to make travel planning effortless.

### Key Features

- **🤖 AI-Powered Planning** - Smart recommendations powered by AI agents
- **✈️ Flight Booking** - Integrated flight search and booking with autocomplete
- **📅 Itinerary Management** - Create and organize detailed day-by-day itineraries
- **💰 Expense Tracking** - Track and manage trip expenses in real-time
- **🎒 Smart Packing** - AI-generated packing lists customized to your destination and trip type
- **📍 Point of Interest Discovery** - Explore and save POIs with AI recommendations
- **💬 Travel Chat** - AI chatbot for travel advice and questions
- **👥 Travel Partners** - Collaborate with travel companions in real-time
- **🏨 Lodging Management** - Book and track accommodations
- **📝 Trip Notes** - Keep detailed notes and observations
- **🌍 Cultural Preparation** - Learn etiquette and cultural tips for your destination
- **📸 Social Sharing** - Share travel experiences through posts
- **💾 Cloud Sync** - All data synced across devices via Firebase

## 🏗️ Architecture

Tripora follows a layered architecture pattern:

```
lib/
├── core/                    # Core business logic
│   ├── models/             # Data models
│   ├── repositories/       # Data access layer
│   ├── services/           # External API integration
│   ├── theme/              # App styling & colors
│   ├── reusable_widgets/   # Reusable UI components
│   ├── utils/              # Utility functions
│   └── viewmodels/         # State management
├── features/               # Feature-specific implementations
│   ├── auth/               # Authentication
│   ├── chat/               # Chat functionality
│   ├── expense/            # Expense tracking
│   ├── exploration/        # POI discovery
│   ├── feedback/           # User feedback
│   ├── home/               # Home screen
│   ├── itinerary/          # Itinerary management
│   ├── navigation/         # Navigation setup
│   ├── packing/            # Packing management
│   ├── poi/                # Point of Interest
│   ├── profile/            # User profile
│   ├── settings/           # App settings
│   ├── trip/               # Trip management
│   └── user/               # User management
└── main.dart               # App entry point
```

### Technology Stack

- **Framework**: Flutter 3.8.1+
- **Language**: Dart
- **State Management**: Provider 6.0.5
- **Backend**: Firebase (Auth, Firestore, Storage)
- **APIs**: Google Places, Google Maps
- **Local Storage**: JSON files via path_provider
- **UI Libraries**: 
  - Cupertino Icons
  - Lucide Icons
  - Flutter Staggered Grid View
  - Table Calendar
  - Marquee
  - Image Picker

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK
- Xcode (for iOS development)
- Android Studio (for Android development)
- Firebase account
- Google Places API key
- Google Maps API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Tripora
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create a `.env` file in the root directory
   - Add your API keys:
     ```
     GOOGLE_PLACES_API_KEY=your_key_here
     GOOGLE_MAPS_API_KEY=your_key_here
     ```

4. **Configure Firebase**
   - For Android: Ensure `android/app/google-services.json` is present
   - For iOS: Ensure `ios/Runner/GoogleService-Info.plist` is present
   - Run: `flutterfire configure`

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

### Core Module

- **models/**: Data classes (User, Trip, Expense, Flight, etc.)
- **repositories/**: Abstract data access layer for all entities
- **services/**: Integration with Firebase, Google APIs, and AI services
  - `firebase_auth_service.dart` - Authentication
  - `firebase_firestore_service.dart` - Database operations
  - `place_auto_complete_service.dart` - Google Places autocomplete
  - `ai_agents_service.dart` - AI agent interactions
  - `map_service.dart` - Google Maps integration
- **theme/**: App-wide styling and color schemes
- **reusable_widgets/**: Shared UI components

### Features Module

Each feature follows a modular structure:
- **views/**: UI screens and page layouts
- **widgets/**: Feature-specific widgets
- **viewmodels/**: Business logic and state management

## 🔑 Key Services

### AI Services
- **AI Agents** - Intelligent travel recommendations
- **AI Chatbot** - Travel advice and Q&A
- **AI Description Generator** - Smart location/activity descriptions
- **Smart Packing** - AI-generated customized packing lists
- **For You Recommender** - Personalized activity recommendations

### External Integrations
- **Firebase Authentication** - User login & registration
- **Cloud Firestore** - Real-time database
- **Firebase Storage** - Image and file storage
- **Google Places API** - Location search and details
- **Google Maps** - Map visualization and routing
- **Flight Autocomplete** - Flight booking integration

## 🛠️ Development

### Building

```bash
# Debug build
flutter build apk --debug          # Android
flutter build ios --debug          # iOS

# Release build
flutter build apk --release        # Android
flutter build ios --release        # iOS
```

### Testing

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Formatting

```bash
dart format lib/
```

## 📚 Documentation

- [System Architecture](docs/architecture.md) - High-level system design
- [Flight Autocomplete Setup](docs/flight_autocomplete_setup.md) - Flight API configuration

## 🔐 Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable authentication methods (Email/Password, Google Sign-In)
3. Create Firestore database
4. Set up Firebase Storage
5. Download and configure service files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)

## 🌍 API Configuration

### Google Places API
- Enable in Google Cloud Console
- Add API key to `.env` file
- Configure in `place_auto_complete_service.dart`

### Google Maps API
- Enable in Google Cloud Console
- Add API key to `.env` file
- Configure in iOS and Android manifest files

## 📦 Dependencies

See [pubspec.yaml](pubspec.yaml) for complete dependency list.

Key dependencies:
- `provider` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` - Backend
- `google_maps_flutter` - Maps integration
- `image_picker`, `flutter_image_compress` - Media handling
- `intl`, `table_calendar` - Date/time utilities
- `http` - HTTP requests
- `uuid` - Unique identifier generation

## 🎨 Theming

The app uses a custom theme system defined in `lib/core/theme/`:
- **Colors**: Defined in `app_colors.dart`
- **Shadows**: Defined in `app_shadow_theme.dart`
- **Typography**: Manrope font family with multiple weights

## 🔄 State Management

Tripora uses **Provider** for state management:
- ViewModels extend `ChangeNotifier` for reactive updates
- Repositories handle data access
- Services integrate with external APIs
- UI widgets consume providers for reactive UI updates

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📄 License

This project is private and not licensed for public use.

## 👥 Authors

Developed as a Capstone Project for Bachelor in Computer Science - Year 3, Semester 2

## 📞 Support

For questions or issues, please contact the development team.

## 🙏 Acknowledgments

- Flutter and Dart communities
- Firebase team
- Google Maps and Places API teams
- All open-source contributors
