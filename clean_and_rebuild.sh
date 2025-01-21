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

# Delete the build directory if it exists
if [ -d "build" ]; then
    xattr -w com.apple.xcode.CreatedByBuildSystem true build
    rm -rf build
fi

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean the Xcode project again
xcodebuild clean

# Delete the build directory again if it exists
if [ -d "build" ]; then
    xattr -w com.apple.xcode.CreatedByBuildSystem true build
    rm -rf build
fi

# Navigate back to the project root
cd ..

# Ensure proper permissions for the current user
sudo chown -R $(whoami) .

# Run flutter clean
flutter clean

# Run flutter pub get
flutter pub get

# Navigate to the iOS directory
cd ios

# Run pod install
pod install

# Navigate back to the project root
cd ..

# Run the Flutter app with the production environment
flutter run -t lib/main_prod.dart

echo "Clean and rebuild completed." 