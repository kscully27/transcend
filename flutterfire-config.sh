#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'stage', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=trancend-dev \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=app.trancend.dev \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --android-package-name=app.trancend.dev \
      --android-out=android/app/src/dev/google-services.json
    ;;
  stage)
    flutterfire config \
      --project=trancend-stage \
      --out=lib/firebase_options_stage.dart \
      --ios-bundle-id=app.trancend.stage \
      --ios-out=ios/flavors/stage/GoogleService-Info.plist \
      --android-package-name=app.trancend.stage \
      --android-out=android/app/src/stage/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=trancend-prod \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=app.trancend \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --android-package-name=app.trancend \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'stage', or 'prod'."
    exit 1
    ;;
esac