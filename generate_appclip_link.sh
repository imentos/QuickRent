#!/bin/bash
#
# Generate App Clip link with landlord phone number
# Creates QR code-ready URL for tenant questionnaires
#

echo "📱 QuickRent App Clip Link Generator"
echo "===================================="
echo ""

# Get property ID
read -p "Property ID (e.g., apt101, house205): " property_id
while [ -z "$property_id" ]; do
    echo "❌ Property ID cannot be empty"
    read -p "Property ID: " property_id
done

# Get landlord phone
read -p "Landlord Phone (with country code, e.g., +15551234567): " phone
while [ -z "$phone" ]; do
    echo "❌ Phone number cannot be empty"
    read -p "Landlord Phone: " phone
done

# URL encode the phone number (replace + with %2B)
encoded_phone=$(echo -n "$phone" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))")

# Generate URLs
production_url="https://quickrent.app/property?id=$property_id&phone=$encoded_phone"
testing_url="quickrent://property?id=$property_id&phone=$encoded_phone"

echo ""
echo "✅ App Clip Links Generated!"
echo "============================"
echo ""
echo "🌐 PRODUCTION URL (for QR codes):"
echo "$production_url"
echo ""
echo "🧪 TESTING URL (for simulator):"
echo "$testing_url"
echo ""

# Save to file
output_file="/tmp/quickrent_appclip_${property_id}.txt"
cat > "$output_file" <<EOF
QuickRent App Clip Configuration
=================================

Property ID: $property_id
Landlord Phone: $phone

Production URL (use for QR codes):
$production_url

Testing URL (use in simulator):
$testing_url

Generated: $(date)
EOF

echo "💾 Configuration saved to: $output_file"
echo ""
echo "📋 Next Steps:"
echo "1. Copy the PRODUCTION URL above"
echo "2. Generate QR code at: https://www.qr-code-generator.com/"
echo "3. Print and display QR code at your property"
echo ""

# Option to generate QR code (requires qrencode)
if command -v qrencode &> /dev/null; then
    read -p "Generate QR code image now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        qr_file="/tmp/quickrent_${property_id}_qr.png"
        qrencode -o "$qr_file" "$production_url"
        echo "✅ QR code saved to: $qr_file"
        
        # Try to open the file (macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open "$qr_file" 2>/dev/null
        fi
    fi
else
    echo "💡 Tip: Install qrencode to generate QR codes automatically:"
    echo "   macOS: brew install qrencode"
    echo "   Linux: sudo apt-get install qrencode"
fi

# Option to test on simulator
if command -v xcrun &> /dev/null; then
    echo ""
    read -p "Test on iOS Simulator now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Opening App Clip in simulator..."
        xcrun simctl openurl booted "$testing_url"
        echo "✅ Check your simulator!"
    fi
fi

echo ""
echo "🎉 Done! Your App Clip is ready to use."
