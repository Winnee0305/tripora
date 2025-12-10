# Tripora — System Architecture

Below is a high-level system architecture diagram for the Tripora Flutter app. It shows main layers, core services, and external dependencies.

```mermaid
flowchart LR
  subgraph MobileApp [Tripora (Flutter)]
    UI[UI Layer<br/>(Screens & Widgets)]
    State[State Management<br/>(Provider / ChangeNotifier)]
    Domain[Domain / Models<br/>(Poi, User, Review)]
    Services[Services Layer<br/>(Place service, Autocomplete, Auth)]
    LocalStorage[Local Storage<br/>(JSON files, path_provider)]
    UI --> State
    State --> Domain
    State --> Services
    Services --> LocalStorage
  end

  subgraph External
    GooglePlaces[Google Places API]
    FirebaseAuth[Firebase Auth]
    Firestore[Cloud Firestore / Firebase DB]
  end

  UI -- user actions --> State
  Services -- places requests --> GooglePlaces
  Services -- auth actions --> FirebaseAuth
  Services -- app data --> Firestore
  LocalStorage -- saved JSON --> UI

  click Services href "lib/core/services" "Open services folder"
  click UI href "lib/features" "Open features/views"
  click Domain href "lib/core/models" "Open models"
```

Legend
- UI Layer
  - Screens & widgets (e.g., poi_page.dart, poi_header_screen.dart, poi_details_screen.dart).
  - Responsible for rendering, error handling and user interactions.

- State Management
  - Provider/ChangeNotifier (or equivalent) holds app state (current POI, user session).
  - Receives user actions from UI and coordinates calls to services.

- Domain / Models
  - POI, User, Review classes and factories (e.g., Poi.fromPlaceId).
  - Validation and lightweight transformations live here.

- Services Layer
  - Place-related API calls (Google Places) — e.g., place_auto_complete_service.dart.
  - Auth service for user sign-in (Firebase Auth).
  - Persistence to Firestore and local JSON files (raw_place_*.json).

- External Dependencies
  - Google Places API: place details, autocomplete, photos.
  - Firebase Auth & Firestore: user accounts and app data.
  - Local file storage used for caching or debugging saved JSON.

Notes / Troubleshooting pointers
- Null-safety: guard against null values returned from services (e.g., place details parsing). Example locations to check: poi_header_screen.dart, poi_page.dart and Poi.fromPlaceId factory.
- Missing assets: ensure `assets/images/placeholder.png` exists and is declared in pubspec.yaml.
- File locations to inspect:
  - Services: lib/core/services/
  - Views: lib/features/poi/views/
  - Models: lib/core/models/

