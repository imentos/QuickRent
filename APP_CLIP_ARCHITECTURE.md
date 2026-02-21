# QuickRent Architecture - App Clip + Full App

## Overview
QuickRent is split into two targets following the spec:

1. **App Clip** (QuickRentClip) - Tenant pre-screening questionnaire
2. **Full App** (QuickRent) - Landlord dashboard and application management

---

## Architecture

```
┌─────────────────────────────────────────────┐
│           TENANT EXPERIENCE                 │
│                                             │
│  [Scan QR Code / Tap Link]                │
│             ↓                               │
│  [App Clip Launches Instantly]             │
│             ↓                               │
│  [Pre-Screen Questionnaire]                │
│             ↓                               │
│  [Submit via Email]                        │
│             ↓                               │
│  [Confirmation Screen]                     │
│                                             │
│  ❌ NO APP DOWNLOAD REQUIRED               │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         LANDLORD EXPERIENCE                 │
│                                             │
│  [Download Full App from App Store]        │
│             ↓                               │
│  [Dashboard with All Applications]         │
│             ↓                               │
│  [Review / Approve / Reject]               │
│             ↓                               │
│  [Manage Properties & Schedule]            │
│                                             │
│  ✅ FULL APP WITH ALL FEATURES             │
└─────────────────────────────────────────────┘
```

---

## Project Structure

```
QuickRent/
├── QuickRent/                    # FULL APP (Landlord Only)
│   ├── QuickRentApp.swift        
│   ├── ContentView.swift         # Shows LandlordDashboardView
│   ├── Views/
│   │   └── Landlord/
│   │       ├── LandlordDashboardView.swift    # Main dashboard
│   │       └── ApplicationDetailView.swift     # Application details
│   └── ViewModels/
│       └── LandlordDashboardViewModel.swift    # Dashboard logic
│
├── QuickRentClip/                # APP CLIP (Tenant Questionnaire)
│   ├── QuickRentClipApp.swift    # App Clip entry point
│   └── (Shares views below)
│
└── Shared/                       # SHARED CODE
    ├── Models/
    │   └── Question.swift        # Data models
    ├── ViewModels/
    │   └── QuestionnaireViewModel.swift
    └── Views/
        ├── QuestionRowView.swift
        ├── QuestionnaireView.swift
        ├── EmailComposerView.swift
        └── ConfirmationView.swift
```

---

## Target Configuration

### App Clip Target (QuickRentClip)
**Purpose:** Tenant pre-screening only  
**Entry Point:** `QuickRentClipApp.swift`  
**Size Limit:** 10MB compressed  
**Features:**
- ✅ Pre-screening questionnaire
- ✅ Email submission
- ✅ Confirmation screen
- ❌ No dashboard
- ❌ No application management

**Invocation:**
- QR code scan
- NFC tag tap
- Smart App Banner
- Messages/Safari links
- URL: `https://quickrent.app/property?id=apt101`

### Full App Target (QuickRent)
**Purpose:** Landlord application management  
**Entry Point:** `QuickRentApp.swift`  
**Features:**
- ✅ Dashboard with all applications
- ✅ Application detail view
- ✅ Approve/Reject actions
- ✅ Property management
- ✅ Notes and search
- ✅ Settings
- ❌ No questionnaire (that's App Clip only)

---

## Setup Instructions

### Step 1: Create App Clip Target in Xcode

1. **Add App Clip Target:**
   - File → New → Target
   - Select "App Clip"
   - Name: `QuickRentClip`
   - Bundle ID: `com.yourcompany.QuickRent.Clip`

2. **Configure Entitlements:**
   ```xml
   <!-- QuickRentClip.entitlements -->
   <key>com.apple.developer.parent-application-identifiers</key>
   <array>
       <string>$(AppIdentifierPrefix)com.yourcompany.QuickRent</string>
   </array>
   <key>com.apple.developer.associated-domains</key>
   <array>
       <string>appclips:quickrent.app</string>
   </array>
   ```

3. **Add Files to App Clip Target:**
   - Select `QuickRentClipApp.swift` → Target Membership: QuickRentClip
   - Select Shared Views/Models → Target Membership: Both targets
   - QuestionnaireView, QuestionRowView, EmailComposerView, ConfirmationView
   - Question.swift, QuestionnaireViewModel.swift

4. **Add Files to Full App Target:**
   - LandlordDashboardView.swift → QuickRent only
   - ApplicationDetailView.swift → QuickRent only
   - LandlordDashboardViewModel.swift → QuickRent only

### Step 2: Configure Associated Domains

1. **Create AASA File** (Apple App Site Association)
   Host at: `https://quickrent.app/.well-known/apple-app-site-association`

```json
{
  "appclips": {
    "apps": ["TEAMID.com.yourcompany.QuickRent.Clip"]
  },
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": ["TEAMID.com.yourcompany.QuickRent.Clip"],
        "components": [
          {
            "/": "/property",
            "?": { "id": "*" }
          }
        ]
      }
    ]
  }
}
```

2. **Add Associated Domains in Xcode:**
   - QuickRentClip target → Signing & Capabilities
   - Add "Associated Domains"
   - Add: `appclips:quickrent.app`

### Step 3: Configure App Clip Card

In App Store Connect → App Clips:
- **Title:** "Pre-Screen in Seconds"
- **Subtitle:** "Quick rental application"
- **Action:** "Start Pre-Screen"
- **Header Image:** Property photo (3000x2000)
- **App Clip URL:** `https://quickrent.app/property?id=apt101`

### Step 4: Generate QR Codes

Use App Clip Code Generator (Apple):
- Visit: https://developer.apple.com/app-clips/
- Generate QR code for each property
- Format: `https://quickrent.app/property?id={propertyId}`
- Print and place at properties

---

## File Membership Guide

| File | Full App | App Clip | Notes |
|------|----------|----------|-------|
| QuickRentApp.swift | ✅ | ❌ | Full app entry |
| QuickRentClipApp.swift | ❌ | ✅ | App Clip entry |
| ContentView.swift | ✅ | ❌ | Landlord dashboard |
| LandlordDashboardView.swift | ✅ | ❌ | Landlord only |
| ApplicationDetailView.swift | ✅ | ❌ | Landlord only |
| LandlordDashboardViewModel.swift | ✅ | ❌ | Landlord only |
| Question.swift | ✅ | ✅ | Shared model |
| QuestionnaireViewModel.swift | ✅ | ✅ | Shared logic |
| QuestionnaireView.swift | ❌ | ✅ | Tenant only |
| QuestionRowView.swift | ❌ | ✅ | Tenant only |
| EmailComposerView.swift | ❌ | ✅ | Tenant only |
| ConfirmationView.swift | ❌ | ✅ | Tenant only |

---

## Testing App Clip

### Local Testing (iOS 15.4+)

1. **Using Xcode:**
   - Select QuickRentClip scheme
   - Run on device
   - Environment Variable: `_XCAppClipURL`
   - Value: `https://quickrent.app/property?id=apt101`

2. **Using Test URL:**
   - Create file: `test-app-clip.html`
   ```html
   <a href="https://quickrent.app/property?id=apt101">
     Test App Clip
   </a>
   ```
   - Host on local server
   - Open in Safari on device
   - Tap link → App Clip Card appears

3. **Using Local Experiences (Xcode 13+):**
   - Xcode → Product → Run App Clip Experience
   - Test different property IDs
   - Test card appearance and launch

---

## User Flows

### Tenant Flow (App Clip)
```
1. Scan QR code at property
   ↓
2. App Clip Card appears
   "Pre-Screen in Seconds"
   [Start Pre-Screen] button
   ↓
3. App Clip launches (< 2 seconds)
   ↓
4. Questionnaire displays
   Property: APT101
   ↓
5. Fill 6 questions
   ↓
6. Tap "Submit Pre-Screen"
   ↓
7. Email composer opens
   (Pre-filled with responses)
   ↓
8. Tap "Send"
   ↓
9. Confirmation screen
   "Pre-Screen Submitted! ✅"
   ↓
10. Tap "Done" and close
    ❌ NO APP DOWNLOAD
```

### Landlord Flow (Full App)
```
1. Download QuickRent from App Store
   (One-time installation)
   ↓
2. Open app → Dashboard
   Shows stats:
   - Total applications: 5
   - Pending: 3
   - Approved: 2
   ↓
3. Tap application to view details
   ↓
4. Review tenant information:
   - Income: $6,000
   - Occupants: 2
   - Pets: No
   - Move-in: March 1
   ↓
5. Add notes (optional)
   ↓
6. Tap "Approve" or "Reject"
   ↓
7. Application status updated
   ↓
8. (Future) Schedule showing
   (Future) Send message to tenant
```

---

## Key Differences

| Feature | App Clip | Full App |
|---------|----------|----------|
| **Download required** | ❌ No | ✅ Yes |
| **Size** | < 10MB | Any size |
| **Launch time** | < 2 seconds | Normal |
| **Questionnaire** | ✅ Yes | ❌ No |
| **Dashboard** | ❌ No | ✅ Yes |
| **Manage applications** | ❌ No | ✅ Yes |
| **User** | Tenant | Landlord |
| **Persistence** | 8 hours | Permanent |
| **Background updates** | ❌ No | ✅ Yes |
| **Push notifications** | ❌ No | ✅ Yes |

---

## Development Workflow

### For Tenant Features (App Clip):
1. Select `QuickRentClip` scheme
2. Edit shared views (QuestionnaireView, etc.)
3. Run on device/simulator
4. Test App Clip launching
5. Verify 10MB size limit

### For Landlord Features (Full App):
1. Select `QuickRent` scheme
2. Edit landlord views (LandlordDashboardView, etc.)
3. Run on device/simulator
4. Test dashboard functionality

### For Shared Features:
1. Edit model/viewmodel files
2. Ensure both targets include the file
3. Test both schemes
4. Verify no breaking changes

---

## Next Steps

1. **Create App Clip Target** in Xcode (follow Step 1 above)
2. **Move Files** to correct targets (see File Membership Guide)
3. **Configure Entitlements** (associated domains)
4. **Test App Clip** locally
5. **Set up AASA file** on your domain
6. **Generate QR codes** for properties
7. **Submit to App Store** (Full App + App Clip)

---

## Production Deployment

### Real-World Setup:
1. **Domain:** Purchase/configure `quickrent.app`
2. **AASA File:** Host at `quickrent.app/.well-known/apple-app-site-association`
3. **Property Pages:** Host at `quickrent.app/property?id={propertyId}`
4. **QR Codes:** Generate for each property
5. **Email Server:** Configure landlord email in App Clip
6. **App Store:** Submit both targets together

### Property-Specific URLs:
- `https://quickrent.app/property?id=apt101`
- `https://quickrent.app/property?id=apt202`
- `https://quickrent.app/property?id=house305`

Each URL:
- Shows App Clip Card
- Launches questionnaire
- Pre-fills property ID
- Sends to correct landlord

---

## Summary

✅ **App Clip (QuickRentClip):** Tenant questionnaire (no download)  
✅ **Full App (QuickRent):** Landlord dashboard (download required)  
✅ **Shared Code:** Models and questionnaire logic  
✅ **Serverless:** Email-based submission (MVP)  
✅ **Scalable:** Ready for backend integration later  

This architecture follows the spec exactly:
- Tenants **never download the app** (App Clip only)
- Landlords **download the full app** (dashboard + management)
- Lean MVP with room to grow
