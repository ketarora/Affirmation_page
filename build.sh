#!/bin/bash
# ════════════════════════════════════════════════════════════════════
#  NISHAFFS v1.0 - DEPLOYMENT SCRIPT
#  Run this to build and prepare for app store submission
# ════════════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════════"
echo "  NISHAFFS v1.0 - PRODUCTION BUILD"
echo "═══════════════════════════════════════════════════════════════════"

# Step 1: Clean and get dependencies
echo ""
echo "📦 Step 1: Setting up dependencies..."
flutter clean
flutter pub get
flutter pub upgrade

# Step 2: Run analyzer
echo ""
echo "🔍 Step 2: Code analysis..."
flutter analyze

if [ $? -ne 0 ]; then
    echo "❌ Fix errors above before proceeding"
    exit 1
fi

# Step 3: Format code
echo ""
echo "✨ Step 3: Formatting code..."
dart format lib/ --set-exit-if-changed

# Step 4: Build APK for Android
echo ""
echo "🤖 Step 4: Building Android APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo "✅ Android APK built: build/app/outputs/apk/release/app-release.apk"
else
    echo "❌ Android build failed"
    exit 1
fi

# Step 5: Build AAB for Google Play
echo ""
echo "📱 Step 5: Building Android App Bundle..."
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo "✅ Android AAB built: build/app/outputs/bundle/release/app-release.aab"
else
    echo "❌ Android AAB build failed"
    exit 1
fi

# Step 6: Build iOS
echo ""
echo "🍎 Step 6: Building iOS..."
flutter build ios --release

if [ $? -eq 0 ]; then
    echo "✅ iOS build prepared"
else
    echo "❌ iOS build failed"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ BUILD COMPLETE - READY FOR SUBMISSION"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Android: Upload AAB to Google Play Console"
echo "2. iOS: Archive and upload to App Store Connect"
echo ""
echo "Files ready:"
echo "  • APK: build/app/outputs/apk/release/app-release.apk"
echo "  • AAB: build/app/outputs/bundle/release/app-release.aab"
echo ""
