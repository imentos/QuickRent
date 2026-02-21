# QuickRent Setup - Quick Start Guide

## ✅ What's Been Created

### Full App (Landlord) - QuickRent Target
- ✅ `ContentView.swift` - Now shows LandlordDashboardView
- ✅ `Views/Landlord/LandlordDashboardView.swift` - Dashboard with stats and applications
- ✅ `Views/Landlord/ApplicationDetailView.swift` - Detailed application review
- ✅ `ViewModels/LandlordDashboardViewModel.swift` - Dashboard logic

### App Clip (Tenant) - QuickRentClip Target (To Be Created)
- ✅ `QuickRentClip/QuickRentClipApp.swift` - App Clip entry point
- ✅ Questionnaire views (ready to share between targets)

### Shared Code
- ✅ `Models/Question.swift`
- ✅ `ViewModels/QuestionnaireViewModel.swift`
- ✅ `Views/QuestionnaireView.swift`
- ✅ `Views/QuestionRowView.swift`
- ✅ `Views/EmailComposerView.swift`
- ✅ `Views/ConfirmationView.swift`

---

## 🚀 Next Steps - Create App Clip Target

### Step 1: Add App Clip Target in Xcode

1. **Open your project in Xcode**
   ```bash
   open QuickRent.xcodeproj
   ```

2. **Add App Clip Target:**
   - File → New → Target
   - Select **"App Clip"** (under iOS)
   - Click **Next**
   
   **Configuration:**
   - Product Name: `QuickRentClip`
   - Team: (Your development team)
   - Organization Identifier: `com.yourcompany` (change to your domain)
   - Bundle Identifier: `com.yourcompany.QuickRent.Clip` (auto-generated)
   - Language: Swift
   - User Interface: SwiftUI
   
   - Click **Finish**
   - When asked "Activate QuickRentClip scheme?", click **Activate**

### Step 2: Configure App Clip Files

1. **Delete default files in QuickRentClip folder:**
   - Delete: `QuickRentClipApp.swift` (Xcode generated)
   - Delete: `ContentView.swift` (Xcode generated)

2. **Move our QuickRentClipApp.swift:**
   - Find: `/QuickRent/QuickRentClip/QuickRentClipApp.swift` (we created it)
   - Select file in Xcode navigator
   - File Inspector → Target Membership
   - ✅ Check: `QuickRentClip`
   - ❌ Uncheck: `QuickRent`

3. **Add Shared Files to App Clip Target:**
   
   For each file below, select it → File Inspector → Target Membership:
   
   **Models (both targets):**
   - `Models/Question.swift` → ✅ QuickRent ✅ QuickRentClip
   
   **ViewModels:**
   - `ViewModels/QuestionnaireViewModel.swift` → ✅ QuickRent ✅ QuickRentClip
   - `ViewModels/LandlordDashboardViewModel.swift` → ✅ QuickRent ❌ QuickRentClip
   
   **Views (Tenant - App Clip only):**
   - `Views/QuestionnaireView.swift` → ❌ QuickRent ✅ QuickRentClip
   - `Views/QuestionRowView.swift` → ❌ QuickRent ✅ QuickRentClip
   - `Views/EmailComposerView.swift` → ❌ QuickRent ✅ QuickRentClip
   - `Views/ConfirmationView.swift` → ❌ QuickRent ✅ QuickRentClip
   
   **Views (Landlord - Full App only):**
   - `Views/Landlord/LandlordDashboardView.swift` → ✅ QuickRent ❌ QuickRentClip
   - `Views/Landlord/ApplicationDetailView.swift` → ✅ QuickRent ❌ QuickRentClip

### Step 3: Configure Entitlements

1. **App Clip Entitlements:**
   - Select `QuickRentClip` target
   - Signing & Capabilities tab
   - Click **+ Capability**
   - Add: **Associated Domains**
   - Add entry: `appclips:quickrent.app` (change domain to yours)

2. **Parent Application:**
   - File: `QuickRentClip.entitlements` (auto-created)
   - Verify it contains:
   ```xml
   <key>com.apple.developer.parent-application-identifiers</key>
   <array>
       <string>$(AppIdentifierPrefix)com.yourcompany.QuickRent</string>
   </array>
   ```

### Step 4: Update Info.plist

1. **App Clip Info.plist:**
   - File: `QuickRentClip/Info.plist`
   - Add key: `NSAppClip`
   - Add sub-key: `NSAppClipRequestEphemeralUserNotification` → YES
   - Add sub-key: `NSAppClipRequestLocationConfirmation` → NO (we don't need location)

### Step 5: Test Locally

1. **Select QuickRentClip Scheme:**
   - Xcode toolbar → Scheme dropdown → QuickRentClip
   
2. **Run on Device:**
   - Select your iPhone (not simulator for full App Clip testing)
   - Click Run (⌘R)
   - App should launch showing questionnaire

3. **Test App Clip URL (Optional):**
   - Edit Scheme → Run → Arguments
   - Environment Variables → Add:
     - Name: `_XCAppClipURL`
     - Value: `https://quickrent.app/property?id=apt101`
   - Run again to test URL handling

### Step 6: Test Full App

1. **Select QuickRent Scheme:**
   - Xcode toolbar → Scheme dropdown → QuickRent
   
2. **Run on Device:**
   - Click Run (⌘R)
   - App should launch showing landlord dashboard

---

## 🎯 Verification Checklist

After setup, verify:

### App Clip (QuickRentClip):
- [ ] Launches to questionnaire screen
- [ ] Shows property ID in header
- [ ] Can fill all 6 questions
- [ ] Validation works (try submitting empty)
- [ ] Email composer opens with pre-filled data
- [ ] Confirmation screen shows after send
- [ ] App size < 10MB (check in Archive)

### Full App (QuickRent):
- [ ] Launches to landlord dashboard
- [ ] Shows stats cards (Total, Pending, Approved)
- [ ] Shows sample applications (2 entries)
- [ ] Can tap application to see details
- [ ] Application detail shows all info
- [ ] Can add notes
- [ ] Approve/Reject buttons work

---

## 📋 File Organization Summary

```
QuickRent.xcodeproj
│
├── QuickRent/                    # Full App Target
│   ├── QuickRentApp.swift        ✅ Shows landlord dashboard
│   ├── ContentView.swift         ✅ LandlordDashboardView
│   ├── Models/
│   │   └── Question.swift        ✅ Shared with App Clip
│   ├── ViewModels/
│   │   ├── QuestionnaireViewModel.swift     ✅ Shared
│   │   └── LandlordDashboardViewModel.swift ✅ Full App only
│   └── Views/
│       ├── Landlord/
│       │   ├── LandlordDashboardView.swift  ✅ Full App only
│       │   └── ApplicationDetailView.swift  ✅ Full App only
│       ├── QuestionnaireView.swift          ✅ App Clip only
│       ├── QuestionRowView.swift            ✅ App Clip only
│       ├── EmailComposerView.swift          ✅ App Clip only
│       └── ConfirmationView.swift           ✅ App Clip only
│
└── QuickRentClip/                # App Clip Target
    ├── QuickRentClipApp.swift    ✅ Shows questionnaire
    └── (Shares files from above)
```

---

## 🐛 Troubleshooting

### Issue: "QuickRentClipApp.swift not found"
**Solution:** 
- Make sure you moved the file we created to the App Clip target
- Check File Inspector → Target Membership → QuickRentClip is checked

### Issue: "QuestionnaireView not found in QuickRentClip"
**Solution:**
- Select `Views/QuestionnaireView.swift`
- File Inspector → Target Membership
- Check ✅ QuickRentClip (and uncheck QuickRent)

### Issue: "Cannot find 'LandlordDashboardView' in scope"
**Solution:**
- This is correct! LandlordDashboardView should ONLY be in Full App
- Make sure ContentView.swift has QuickRent target only (not App Clip)

### Issue: App Clip size > 10MB
**Solution:**
- Remove unused assets from App Clip target
- Use asset compression
- Avoid including landlord views in App Clip

---

## 🌐 Production Setup (Later)

When ready to deploy:

1. **Domain Setup:**
   - Purchase domain (e.g., quickrent.app)
   - Host AASA file at `/.well-known/apple-app-site-association`

2. **App Store Connect:**
   - Create app record
   - Configure App Clip
   - Set App Clip URL
   - Upload header image (3000x2000px)
   - Set action: "Start Pre-Screen"

3. **QR Code Generation:**
   - Use Apple's App Clip Code Generator
   - Create codes for each property
   - Print and place at properties

---

## 📞 Next Actions

1. ✅ Follow "Step 1: Add App Clip Target" above
2. ✅ Follow "Step 2: Configure App Clip Files"
3. ✅ Test both schemes (QuickRentClip and QuickRent)
4. ✅ Verify checklist above
5. ✅ Configure your landlord email in QuestionnaireViewModel.swift
6. 📱 Test on physical device

---

## 💡 Key Concepts

**Why Two Targets?**
- **App Clip:** Lightweight, instant launch, no download
- **Full App:** Full features, persistent, App Store download

**Why Shared Files?**
- Models and questionnaire logic are reused
- Reduces duplication
- Easy to maintain

**Why Separate Entry Points?**
- App Clip shows questionnaire (tenant)
- Full App shows dashboard (landlord)
- Different users, different needs

---

**Ready to test!** Follow the steps above and you'll have a working App Clip + Full App setup. 🚀
