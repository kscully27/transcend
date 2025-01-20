#!/bin/bash

echo "Cleaning and rebuilding the project..."

# Navigate to the iOS directory
cd ios

# Remove Podfile.lock and Pods directory
rm Podfile.lock
rm -rf Pods

# Run pod deintegrate
pod deintegrate

# Clean the Xcode project
xcodebuild clean

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Run pod install
pod install

# Navigate back to the project root
cd ..

# Run flutter clean
flutter clean

# Run flutter pub get
flutter pub get

# Run the Flutter app with the production environment
flutter run -t lib/main_prod.dart

echo "Clean and rebuild completed." 