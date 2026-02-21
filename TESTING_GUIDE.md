# QuickRent Universal Link Testing Guide

## Prerequisites
- Two iOS devices (Universal Links require real devices, not simulator)
- Or one device + Safari for testing
- iOS 16.0 or later

---

## Setup Steps

### 1. Configure Xcode Project

#### Add Associated Domains
1. Open QuickRent.xcodeproj
2. Select **QuickRent** target → **Signing & Capabilities**
3. Click **+ Capability** → Add **Associated Domains**
4. Add entries:
   - `appclips:quickrent.app`
   - `applinks:quickrent.app`

5. Select **QuickRentClip** target → **Signing & Capabilities**
6. Click **+ Capability** → Add **Associated Domains**
7. Add same entries as above

#### Update Landlord Phone Number
In `QuickRent/ViewModels/QuestionnaireViewModel.swift`:
```swift
let landlordPhone = "+1234567890"  // ← Change to actual phone number
```

---

## Testing Workflow

### Option 1: End-to-End SMS Test (Requires 2 Devices)

**Device 1 (Tenant):**
1. Run **QuickRentClip** target on Device 1
2. Fill out questionnaire with test data
3. Tap "Send via SMS"
4. Enter landlord's phone number (Device 2)
5. Send SMS

**Device 2 (Landlord):**
1. Run **QuickRent** (Full App) target on Device 2
2. Receive SMS with Universal Link
3. Tap the link in SMS
4. QuickRent app should open automatically
5. Check dashboard for imported application
6. Success alert should appear

### Option 2: Manual Link Test (1 Device + Safari)

**Step 1: Generate Link**
1. Run QuickRentClip on device
2. Fill out questionnaire
3. Tap "Send via SMS"
4. SMS not available? → Fallback view shows
5. Tap "Copy" button to copy Universal Link

**Step 2: Test Import**
1. Switch to **QuickRent** (Full App) target
2. Run on same device
3. Open Safari
4. Paste the Universal Link
5. Tap to open
6. App should open and import application

### Option 3: Xcode URL Simulation

**Step 1: Get Test Link**
In QuickRent scheme, add URL launch argument:

1. **Product** → **Scheme** → **Edit Scheme**
2. Select **Run** → **Arguments**
3. Under "Arguments Passed On Launch", add:
   ```
   -FIRDebugEnabled
   ```

4. Under "Options" tab → "Environment Variables", add:
   ```
   Name: URL
   Value: quickrent://application?data=eyJpZCI6IkU4QzRBNEVELTQzQkItNEU5MS1CNjBELTMwMzBGQjUxOTkyOSIsInByb3BlcnR5SWQiOiJ0ZXN0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJhcHBsaWNhbnROYW1lIjpudWxsLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIzIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6InRlc3RAZXhhbXBsZS5jb20ifX0=
   ```

**Step 2: Programmatic Test**
Add this to `QuickRentApp.swift` for testing:

```swift
.onAppear {
    #if DEBUG
    // Simulate receiving a Universal Link
    testUniversalLinkImport()
    #endif
}

private func testUniversalLinkImport() {
    let testData = ApplicationData(
        propertyId: "test101",
        timestamp: Date(),
        applicantName: "Test User",
        responses: [
            "movein": "March 1, 2026",
            "income": "6000",
            "occupants": "2",
            "pets": "No",
            "smoking": "No",
            "contact": "test@example.com"
        ]
    )
    
    if let link = testData.generateUniversalLink() {
        print("🔗 Test Link Generated:")
        print(link)
        
        if let url = URL(string: link) {
            // Simulate opening the link
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.handleUniversalLink(url)
            }
        }
    }
}
```

---

## Verification Checklist

### ✅ Link Generation (Tenant Side)
- [ ] Questionnaire validation works
- [ ] "Send via SMS" button appears
- [ ] SMS composer opens with pre-filled message
- [ ] Message contains properly formatted link
- [ ] Link length is reasonable (~500-800 chars)
- [ ] Confirmation screen appears after send

### ✅ Link Import (Landlord Side)
- [ ] Tapping link opens QuickRent app
- [ ] Application appears at top of dashboard
- [ ] All data fields populated correctly
- [ ] Success alert displays
- [ ] No duplicate when tapping link again
- [ ] Application status is "Pending"

### ✅ Data Integrity
- [ ] Property ID matches
- [ ] Contact info correct
- [ ] Income amount correct
- [ ] Move-in date formatted properly
- [ ] Yes/No answers formatted correctly
- [ ] Timestamp shows submission time

---

## Sample Test Data

### Test Case 1: Standard Application
```
Property: apt101
Move-in: March 1, 2026
Income: 6000
Occupants: 2
Pets: No
Smoking: No
Contact: test@example.com
```

### Test Case 2: Complex Scenario
```
Property: penthouse-5b
Move-in: April 15, 2026
Income: 12500
Occupants: 4
Pets: Yes - 1 cat, 1 dog
Smoking: No
Contact: 555-987-6543
```

### Test Case 3: Edge Cases
```
Property: studio_west
Move-in: February 28, 2026
Income: 0 (unemployed)
Occupants: 1
Pets: No
Smoking: Yes
Contact: jane.doe+test@example.com
```

---

## Troubleshooting

### Link Doesn't Open App
1. Check Associated Domains configuration
2. Verify AASA file is hosted correctly
3. Try custom URL scheme: `quickrent://` instead of `https://`
4. Check device logs: Settings → Privacy → Analytics → Analytics Data

### SMS Composer Doesn't Open
- iOS Simulator doesn't support SMS
- Run on real device OR
- Use fallback view to copy link manually

### Application Not Imported
1. Check console logs for parsing errors
2. Verify Base64 string is valid
3. Check URL format matches: `?data=BASE64`
4. Ensure JSON structure is correct

### Duplicate Applications Appearing
- Working as intended! Duplicate detection only prevents within 1 minute
- To disable: Comment out duplicate check in `LandlordDashboardViewModel.importApplication()`

### Can't Decode Base64
- Check for URL encoding issues (+, /, = characters)
- Verify Base64 string is complete (no truncation)
- Test with simple payload first

---

## Debug Console Output

### Success Messages:
```
✅ Encoded application data: eyJpZCI6IkU4...
📱 Received URL: https://quickrent.app/application?data=...
✅ Decoded application data for property: apt101
📥 Importing application from Universal Link...
✅ Successfully imported application for apt101
```

### Error Messages:
```
❌ Failed to encode ApplicationData to JSON
❌ Failed to decode Base64 string
❌ Invalid Universal Link format
❌ No data parameter found in Universal Link
⚠️ Duplicate application detected, skipping import
```

---

## Performance Testing

### Link Size Test
```swift
let testData = ApplicationData(...)
if let link = testData.generateUniversalLink() {
    print("Link length: \(link.count) characters")
    // Expected: 450-800 characters
    // iOS SMS limit: 1600 characters (safe)
}
```

### Encoding/Decoding Speed
```swift
let start = Date()
let data = ApplicationData(...)
let link = data.generateUniversalLink()
let decoded = ApplicationData.parseUniversalLink(URL(string: link)!)
let duration = Date().timeIntervalSince(start)
print("Encode+Decode time: \(duration * 1000)ms")
// Expected: < 5ms
```

---

## Production Readiness

Before App Store submission:

1. **Update Domain**
   - Change `quickrent.app` to your actual domain
   - Update all references in code

2. **Host AASA File**
   - Upload to `https://yourdomain.com/.well-known/apple-app-site-association`
   - Verify with Apple's validator

3. **Configure Team ID**
   - Replace `TEAM_ID` in AASA file
   - Match with Xcode signing

4. **Security Enhancements** (Optional)
   - Add link expiration (24-48 hours)
   - Add HMAC signature
   - Encrypt sensitive data

5. **Analytics** (Optional)
   - Log link generation count
   - Track import success rate
   - Monitor decoding errors

---

## Quick Commands

### Generate Test Link in Swift Console:
```swift
import Foundation
let json = #"{"id":"test","propertyId":"apt101","timestamp":"2026-02-21T15:30:00Z","applicantName":null,"responses":{"movein":"March 1, 2026","income":"6000","occupants":"2","pets":"No","smoking":"No","contact":"test@example.com"}}"#
let data = json.data(using: .utf8)!
let base64 = data.base64EncodedString()
print("https://quickrent.app/application?data=\(base64)")
```

### Decode Test Link:
```swift
let base64 = "eyJpZCI6InRlc3QiLCJwcm9wZXJ0eUlkIjoiYXB0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJhcHBsaWNhbnROYW1lIjpudWxsLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIyIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6InRlc3RAZXhhbXBsZS5jb20ifX0="
if let data = Data(base64Encoded: base64),
   let json = String(data: data, encoding: .utf8) {
    print(json)
}
```

---

**Happy Testing! 🧪**
