# Swiftry Rider App

Delivery partner app for Swiftry platform.

## Features
- Auth (mock OTP)
- Home with online/offline toggle, earnings, incoming requests
- Delivery map with flutter_map OSM, stage progression
- Proof of delivery (OTP, photo, signature placeholders)
- Orders history

## Setup
```
flutter pub get
flutter run --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY
```

## Backend TODOs
Search for `TODO Backend:` in lib/

- POST /rider/orders/:id/accept
- POST /rider/orders/:id/stage
- POST /rider/orders/:id/proof
- POST /rider/location every 5 sec
- WebSocket for real-time tracking
