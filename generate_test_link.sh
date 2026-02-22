#!/bin/bash
#
# Generate test link for QuickRent Universal Link testing
# Creates a quickrent:// URL with sample application data
#

echo "🔗 QuickRent Test Link Generator"
echo "================================"
echo ""

# Sample application data
read -p "Property ID [apt101]: " property_id
property_id=${property_id:-apt101}

read -p "Monthly Income [6000]: " income
income=${income:-6000}

read -p "Number of Occupants [2]: " occupants
occupants=${occupants:-2}

read -p "Contact Info [test@example.com]: " contact
contact=${contact:-test@example.com}

echo ""
echo "Generating link..."

# Generate UUID and timestamp
UUID=$(uuidgen)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create compact JSON (no whitespace - critical for proper encoding)
JSON="{\"id\":\"$UUID\",\"propertyId\":\"$property_id\",\"timestamp\":\"$TIMESTAMP\",\"applicantName\":null,\"responses\":{\"movein\":\"March 1, 2026\",\"income\":\"$income\",\"occupants\":\"$occupants\",\"pets\":\"No\",\"smoking\":\"No\",\"contact\":\"$contact\"}}"

# Base64 encode - use -w 0 flag if available (Linux), otherwise pipe through tr (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - base64 adds line breaks by default, remove them
    BASE64=$(echo -n "$JSON" | base64 | tr -d '\n')
else
    # Linux
    BASE64=$(echo -n "$JSON" | base64 -w 0)
fi

# Create link
LINK="quickrent://application?data=$BASE64"

echo ""
echo "✅ Test Link Generated!"
echo "======================="
echo ""
echo "$LINK"
echo ""
echo "📋 How to use:"
echo "1. Copy the link above"
echo "2. Open QuickRent app on device/simulator"
echo "3. Open Safari and paste the link"
echo "4. Tap Go → Should prompt to open in QuickRent"
echo ""
echo "Or on iOS Simulator terminal:"
echo "xcrun simctl openurl booted \"$LINK\""
echo ""

# Option to test immediately on simulator
if command -v xcrun &> /dev/null; then
    read -p "Test on simulator now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Opening link in simulator..."
        xcrun simctl openurl booted "$LINK"
        echo "✅ Link opened! Check the simulator."
    fi
fi

echo ""
echo "💾 Link saved to: /tmp/quickrent_test_link.txt"
echo "$LINK" > /tmp/quickrent_test_link.txt
