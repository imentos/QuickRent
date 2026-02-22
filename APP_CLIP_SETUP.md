# App Clip Setup Guide for Landlords

## Overview
The QuickRent App Clip allows tenants to fill out pre-screening questionnaires by scanning a QR code or tapping a link. This guide shows you how to configure your contact information.

## URL Format

### Basic Format
```
https://quickrent.app/property?id=PROPERTY_ID&phone=PHONE_NUMBER
```

### Example URLs
```
https://quickrent.app/property?id=apt101&phone=%2B15551234567
https://quickrent.app/property?id=house205&phone=%2B14155551234
```

**Important:** Phone numbers must be URL-encoded:
- Replace `+` with `%2B`
- Example: `+1555123456` → `%2B15551234567`

## Generating Your App Clip Link

### Method 1: Using the Generator Script

Run the included script:
```bash
./generate_appclip_link.sh
```

### Method 2: Manual URL Creation

1. **Get your property ID** (e.g., `apt101`, `house205`)
2. **Format your phone number** with country code (e.g., `+15551234567`)
3. **URL encode the phone number:**
   - Online: Use a URL encoder tool
   - macOS Terminal: `echo "+15551234567" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))"`
4. **Build the URL:**
   ```
   https://quickrent.app/property?id=YOUR_PROPERTY_ID&phone=ENCODED_PHONE
   ```

## Creating QR Codes

### Online QR Code Generators
- [QR Code Generator](https://www.qr-code-generator.com/)
- [QR Code Monkey](https://www.qrcode-monkey.com/)
- [The QR Code Generator](https://www.the-qrcode-generator.com/)

### Steps:
1. Generate your App Clip link (see above)
2. Go to a QR code generator
3. Paste your link
4. Download the QR code image
5. Print and display at your property

## Example QR Code Setup

### For Property "Apt 101" with phone "+1555-123-4567"

1. **URL:**
   ```
   https://quickrent.app/property?id=apt101&phone=%2B15551234567
   ```

2. **Display Text on Sign:**
   ```
   ┌─────────────────────────────┐
   │   PRE-SCREEN APPLICATION    │
   │                             │
   │     [QR CODE IMAGE HERE]    │
   │                             │
   │  Scan to fill out a quick   │
   │  2-minute questionnaire     │
   │                             │
   │     Apt 101 - QuickRent     │
   └─────────────────────────────┘
   ```

## Testing Your App Clip

### On iOS 16+ Device:
1. Open Camera app
2. Point at QR code
3. Tap the App Clip notification
4. Verify:
   - Property ID displays correctly
   - Your phone number is pre-configured in SMS
   - Questionnaire loads properly

### Without QR Code:
- Paste your URL in Safari
- Should trigger App Clip card

## What Happens When Tenant Uses App Clip

1. **Tenant scans QR code** → App Clip launches
2. **Tenant sees property ID** at top of questionnaire
3. **Tenant fills out** pre-screening questions
4. **Tenant taps "Send via SMS"** → Your phone pre-filled
5. **SMS sent to you** with application link
6. **You tap link** → Full QuickRent app opens
7. **Application imported** to your dashboard

## Testing Mode (Development)

For testing without domain setup, use custom URL scheme:
```
quickrent://property?id=apt101&phone=%2B15551234567
```

Open in simulator:
```bash
xcrun simctl openurl booted "quickrent://property?id=apt101&phone=%2B15551234567"
```

## Production Deployment Checklist

- [ ] Register domain `quickrent.app`
- [ ] Configure Associated Domains in Xcode
- [ ] Host AASA file at `https://quickrent.app/.well-known/apple-app-site-association`
- [ ] Update URL scheme from `quickrent://` to `https://`
- [ ] Generate QR codes with production URLs
- [ ] Test on physical device with real QR code
- [ ] Print and display QR codes at properties

## Customization Options

### Multiple Properties
Create separate QR codes for each property:
```
Property A: https://quickrent.app/property?id=propertyA&phone=%2B15551234567
Property B: https://quickrent.app/property?id=propertyB&phone=%2B15551234567
```

### Different Phone Numbers per Property
Use different phones for property managers:
```
Building 1: https://quickrent.app/property?id=bldg1&phone=%2B15551111111
Building 2: https://quickrent.app/property?id=bldg2&phone=%2B15552222222
```

## Troubleshooting

### App Clip Doesn't Launch
- ✅ Verify URL format is correct
- ✅ Check phone number is URL-encoded (`%2B` for `+`)
- ✅ Ensure iOS 16+ device
- ✅ Test on different device/network

### Wrong Phone Number Showing
- ✅ Check URL parameter: `phone=ENCODED_NUMBER`
- ✅ Verify URL encoding: `+` must be `%2B`
- ✅ Test with fresh QR code scan

### SMS Not Working
- ✅ Verify device has cellular service
- ✅ Check phone number format: `+1XXXXXXXXXX`
- ✅ Test on physical device (simulators have limited SMS)

## Support
For issues, contact: imentos@gmail.com
