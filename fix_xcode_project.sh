#!/bin/bash
#
# Add missing files to QuickRent Xcode project
# This script adds ApplicationData.swift and SMSComposerView.swift to both targets
#

set -e

PROJECT_DIR="/Users/I818292/Documents/Funs/QuickRent"
cd "$PROJECT_DIR"

echo "🔧 QuickRent - Adding Missing Files to Xcode Project"
echo "=================================================="
echo ""

# Check if files exist
echo "✓ Checking file existence..."
if [ ! -f "QuickRent/Models/ApplicationData.swift" ]; then
    echo "❌ ERROR: ApplicationData.swift not found!"
    exit 1
fi

if [ ! -f "QuickRent/Views/SMSComposerView.swift" ]; then
    echo "❌ ERROR: SMSComposerView.swift not found!"
    exit 1
fi

echo "✓ Files exist on disk"
echo ""

# Check if files are in project
echo "✓ Checking Xcode project..."
APP_DATA_COUNT=$(grep -c "ApplicationData.swift" QuickRent.xcodeproj/project.pbxproj || echo "0")
SMS_VIEW_COUNT=$(grep -c "SMSComposerView.swift" QuickRent.xcodeproj/project.pbxproj || echo "0")

echo "  - ApplicationData.swift references: $APP_DATA_COUNT"
echo "  - SMSComposerView.swift references: $SMS_VIEW_COUNT"
echo ""

if [ "$APP_DATA_COUNT" -gt 0 ] && [ "$SMS_VIEW_COUNT" -gt 0 ]; then
    echo "✓ Files already in project!"
    echo ""
    echo "If you're still seeing errors, try:"
    echo "  1. Clean Build Folder in Xcode (⇧⌘K)"
    echo "  2. Delete Derived Data: rm -rf ~/Library/Developer/Xcode/DerivedData"
    echo "  3. Restart Xcode"
    exit 0
fi

echo "⚠️  Files need to be added to Xcode project"
echo ""
echo "AUTOMATIC FIX OPTION:"
echo "Open Xcode and run this AppleScript to add files automatically..."
echo ""

# Generate AppleScript to add files
cat > /tmp/add_files_to_xcode.scpt << 'EOF'
tell application "Xcode"
    activate
    delay 1
end tell

tell application "System Events"
    tell process "Xcode"
        -- Add ApplicationData.swift
        keystroke "n" using {command down, option down}
        delay 0.5
        keystroke "a" using command down
        keystroke "/Users/I818292/Documents/Funs/QuickRent/QuickRent/Models/ApplicationData.swift"
        delay 0.5
        keystroke return
        
        -- Add SMSComposerView.swift  
        keystroke "n" using {command down, option down}
        delay 0.5
        keystroke "a" using command down
        keystroke "/Users/I818292/Documents/Funs/QuickRent/QuickRent/Views/SMSComposerView.swift"
        delay 0.5
        keystroke return
    end tell
end tell
EOF

echo "❌ UNABLE TO AUTO-ADD (Xcode project file is complex)"
echo ""
echo "📋 MANUAL STEPS REQUIRED:"
echo ""
echo "1. Open QuickRent.xcodeproj in Xcode:"
echo "   open QuickRent.xcodeproj"
echo ""
echo "2. For each missing file:"
echo "   a. Right-click 'Models' or 'Views' folder in Project Navigator"
echo "   b. Select 'Add Files to QuickRent...'"
echo "   c. Navigate to and select the file:"
echo "      • QuickRent/Models/ApplicationData.swift"
echo "      • QuickRent/Views/SMSComposerView.swift"
echo "   d. ⚠️  IMPORTANT: Check both targets:"
echo "      ☑️  QuickRent"
echo "      ☑️  QuickRentClip"
echo "   e. Uncheck 'Copy items if needed' (files already in place)"
echo "   f. Click 'Add'"
echo ""
echo "3. Clean and build:"
echo "   • Product → Clean Build Folder (⇧⌘K)"
echo "   • Product → Build (⌘B)"
echo ""
echo "4. Expected result: ✅ BUILD SUCCEEDED"
echo ""
echo "See XCODE_FIX_GUIDE.md for detailed instructions with screenshots"
echo ""

# Offer to open Xcode
read -p "Open Xcode now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Opening Xcode..."
    open QuickRent.xcodeproj
    echo ""
    echo "📖 Follow the manual steps above to add the files"
    echo "   Or see: XCODE_FIX_GUIDE.md"
fi

echo ""
echo "Done! 🚀"
