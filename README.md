# DBpro Mobile

Cross-platform Flutter application for DBpro Central monitoring.

## Targets
- Android (APK/AAB)
- iOS (IPA)

## Implemented foundation
- Login to existing DBpro Central API
- Secure access-token storage
- Biometric authentication service
- Monitoring dashboard with 2-second refresh
- CPU, Memory, Disk and Network cards
- Realtime series charts
- Service & Container status
- Incident history
- LIVE/OFFLINE state
- Light/Dark mode
- Logout and automatic handling of expired sessions

## Native bootstrap required
This repository was initialized remotely and currently contains the Flutter application layer. Before building APK/AAB/IPA, run Flutter project bootstrap locally so Flutter generates the native `android/` and `ios/` folders.

After native bootstrap, configure `local_auth` requirements for Android biometric authentication and iOS Face ID/Touch ID, then test on real devices.

The existing Java-native DBpro application remains separate and is used as the migration reference.
