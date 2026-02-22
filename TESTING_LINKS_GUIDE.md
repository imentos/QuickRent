# Testing Universal Links - Quick Setup

## 🚨 Why Links Don't Open the App

Universal Links (`https://quickrent.app/...`) require:
1. ✅ Real domain (quickrent.app)
2. ✅ AASA file hosted on domain
3. ✅ Associated Domains in Xcode
4. ✅ App signed with Team ID

**For testing, we use a custom URL scheme instead:** `quickrent://`

---

## ⚡ Quick Test Setup (5 minutes)

### Step 1: Add URL Scheme in Xcode

1. Open `QuickRent.xcodeproj`
2. Select **QuickRent** target (not QuickRentClip)
3. Go to **Info** tab
4. Scroll to **URL Types** section
5. Click **+** to add new URL Type
6. Set:
   - **Identifier:** `com.yourcompany.quickrent`
   - **URL Schemes:** `quickrent`
   - **Role:** Editor
7. Build the app (⌘B)

### Step 2: Test Link Import

#### Option A: Test from Safari on Device/Simulator

1. Run **QuickRent** (Full App) on device/simulator
2. Open Safari on same device
3. Paste this test link in address bar:
   ```
   quickrent://application?data=eyJpZCI6IkU4QzRBNEVELTQzQkItNEU5MS1CNjBELTMwMzBGQjUxOTkyOSIsInByb3BlcnR5SWQiOiJ0ZXN0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNjowMDowMFoiLCJhcHBsaWNhbnROYW1lIjpudWxsLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIyIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6InRlc3RAZXhhbXBsZS5jb20ifX0=
   ```
4. Tap Go
5. Should see prompt: **"Open in QuickRent?"**
6. Tap **Open**
7. ✅ App opens and imports application!

#### Option B: Test from Terminal (Simulator Only)

```bash
# Start simulator and run QuickRent app first
xcrun simctl openurl booted "quickrent://application?data=eyJpZCI6IkU4QzRBNEVELTQzQkItNEU5MS1CNjBELTMwMzBGQjUxOTkyOSIsInByb3BlcnR5SWQiOiJ0ZXN0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNjowMDowMFoiLCJhcHBsaWNhbnROYW1lIjpudWxsLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIyIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6InRlc3RAZXhhbXBsZS5jb20ifX0="
```

#### Option C: Test from Notes/Messages

1. Run QuickRent app
2. Open Notes app
3. Type/paste the test link
4. Tap the link
5. Should open QuickRent app

---

## 📱 End-to-End Test Flow

### Full Workflow Test:

1. **Build QuickRentClip** on device
2. Fill questionnaire with test data
3. Tap "Send via SMS"
4. If on simulator: Copy link from fallback view
5. If on device: Send SMS to yourself
6. **Switch to QuickRent (Full App)** target and run
7. Tap the link (in SMS or paste in Safari)
8. ✅ App should open and show imported application

---

## 🔍 Troubleshooting

### "Cannot open page" error
- ✅ Add URL scheme in Xcode (see Step 1)
- ✅ Build the app after adding URL scheme
- ✅ Make sure QuickRent app is installed

### App doesn't open
- Check Console.app for error messages
- Verify URL scheme is `quickrent` (lowercase)
- Try restarting the app

### Link opens Safari instead of app
- First time requires user to tap "Open in QuickRent"
- Subsequent taps should open app directly

### Data doesn't import
- Check Xcode console for error messages
- Look for "📱 Received URL:" log
- Verify Base64 data is complete (no truncation)

---

## 🧪 Generate Your Own Test Link

### In Xcode Debug Console:

While running the app, paste this in console:

```swift
import Foundation

let testData: [String: Any] = [
    "id": UUID().uuidString,
    "propertyId": "test101",
    "timestamp": ISO8601DateFormatter().string(from: Date()),
    "applicantName": NSNull(),
    "responses": [
        "movein": "March 1, 2026",
        "income": "6000",
        "occupants": "2",
        "pets": "No",
        "smoking": "No",
        "contact": "test@example.com"
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: testData)
let base64 = jsonData.base64EncodedString()
let link = "quickrent://application?data=\(base64)"
print("Test link: \(link)")
```

Then copy the output and test!

---

## ✅ Verification Checklist

After successful test:

- [ ] Link opens QuickRent app
- [ ] Console shows: "📱 Received URL: quickrent://..."
- [ ] Console shows: "✅ Decoded application data for property: test101"
- [ ] Console shows: "📥 Importing application..."
- [ ] Dashboard shows new application
- [ ] Success alert appears
- [ ] Application details are correct

---

## 🚀 Production Setup (Later)

When ready to publish:

1. Register domain (quickrent.app)
2. Host AASA file at `/.well-known/apple-app-site-association`
3. Add Associated Domains in Xcode:
   - `applinks:quickrent.app`
   - `appclips:quickrent.app`
4. Change `generateUniversalLink(useCustomScheme: true)` to `false`
5. Build with production certificate

---

## 📊 What Changed

Updated `ApplicationData.swift`:
- ✅ Now generates `quickrent://` links by default (testing)
- ✅ Accepts both `quickrent://` and `https://` schemes
- ✅ Can switch to production with one parameter change
- ✅ Better error messages

---

**Ready to test!** Just add the URL scheme in Xcode and try the test link. 🎯
