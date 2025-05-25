#!/bin/bash

#example file name - upload_apk.sh

flutter build apk --release --flavor prod -t lib/main_prod.dart --split-per-abi

# Step 2: Set variables
APK_PATH="build/app/outputs/flutter-apk/app-armeabi-v7a-prod-release.apk"
APP_ID="1:561909823794:android:53dd1f51f42419496cbf2b"
RELEASE_NOTES_FILE_PATH="release-notes.txt"
TESTERS_GROUP="al"

# Step 3: Upload the APK to Firebase App Distribution with additional details
firebase appdistribution:distribute $APK_PATH --app $APP_ID \
    --release-notes-file $RELEASE_NOTES_FILE_PATH \
    --groups "$TESTERS_GROUP" \


#TESTERS_EMAILS="alxayeed@gmail.com"
#firebase appdistribution:distribute $APK_PATH --app $APP_ID \
#    --release-notes "Test release note" \
#    --testers "$TESTERS_EMAILS"