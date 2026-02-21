# Quick Start - Configure Target Membership in 5 Minutes ⚡

## Step-by-Step Visual Guide

### 1️⃣ Delete Default App Clip ContentView

**In Xcode:**
```
📁 QuickRentClip
  ├── Assets.xcassets
  ├── ContentView.swift          ← DELETE THIS
  ├── QuickRentClipApp.swift
  └── QuickRentClip.entitlements
```

**How:**
1. In Xcode, click on `QuickRentClip` folder in Navigator
2. Find `ContentView.swift`
3. Right-click → Delete → Move to Trash

---

### 2️⃣ Configure Target Membership (3 minutes)

For each file, click on it → look at **right sidebar** (File Inspector) → check/uncheck boxes:

#### ✅ BOTH Targets (Shared Code)
```
📄 Question.swift
   Target Membership:
   ✅ QuickRent
   ✅ QuickRentClip

📄 QuestionnaireViewModel.swift
   Target Membership:
   ✅ QuickRent
   ✅ QuickRentClip
```

#### ✅ App Clip ONLY (Tenant Questionnaire)
```
📄 QuestionnaireView.swift
   Target Membership:
   ❌ QuickRent
   ✅ QuickRentClip

📄 QuestionRowView.swift
   Target Membership:
   ❌ QuickRent
   ✅ QuickRentClip

📄 EmailComposerView.swift
   Target Membership:
   ❌ QuickRent
   ✅ QuickRentClip

📄 ConfirmationView.swift
   Target Membership:
   ❌ QuickRent
   ✅ QuickRentClip
```

#### ✅ Full App ONLY (Landlord Dashboard)
```
📄 LandlordDashboardView.swift
   Target Membership:
   ✅ QuickRent
   ❌ QuickRentClip

📄 ApplicationDetailView.swift
   Target Membership:
   ✅ QuickRent
   ❌ QuickRentClip

📄 LandlordDashboardViewModel.swift
   Target Membership:
   ✅ QuickRent
   ❌ QuickRentClip

📄 ContentView.swift (in QuickRent folder)
   Target Membership:
   ✅ QuickRent
   ❌ QuickRentClip
```

---

### 3️⃣ Build and Test

#### Test App Clip:
1. **Scheme dropdown** (top left) → Select **"QuickRentClip"**
2. Select iPhone 15 (or your device)
3. Press **⌘R** (or click Play button)
4. **Should see:** Questionnaire with 6 questions ✅

#### Test Full App:
1. **Scheme dropdown** → Select **"QuickRent"**
2. Press **⌘R**
3. **Should see:** Dashboard with stats and applications ✅

---

## 🎯 Quick Reference

| What You Want | File Location | QuickRent | QuickRentClip |
|---------------|---------------|-----------|---------------|
| App entry - Full App | QuickRentApp.swift | ✅ | ❌ |
| App entry - App Clip | QuickRentClipApp.swift | ❌ | ✅ |
| Data models | Question.swift | ✅ | ✅ |
| Questionnaire logic | QuestionnaireViewModel.swift | ✅ | ✅ |
| Tenant form | QuestionnaireView.swift | ❌ | ✅ |
| Landlord dashboard | LandlordDashboardView.swift | ✅ | ❌ |

---

## ⚠️ Common Issues & Fixes

### Issue: "Cannot find 'QuestionnaireView' in scope"
**Where:** Building App Clip  
**Fix:** Add `QuestionnaireView.swift` to QuickRentClip target

### Issue: "Duplicate symbol"
**Where:** Any build  
**Fix:** Delete `QuickRentClip/ContentView.swift` (Xcode's default)

### Issue: App Clip shows dashboard
**Where:** Running App Clip  
**Fix:** Check QuestionnaireView has QuickRentClip target checked

### Issue: Full App shows questionnaire
**Where:** Running Full App  
**Fix:** Check ContentView.swift has only QuickRent target (not App Clip)

---

## 🎉 Done!

When configured correctly:

✅ **App Clip (QuickRentClip):** Tenants see questionnaire, no download  
✅ **Full App (QuickRent):** Landlords see dashboard, manage applications  

**Time:** ~5 minutes  
**Difficulty:** Easy (just clicking checkboxes)  
**Result:** Working App Clip + Full App

---

## 📱 Visual Confirmation

After building both schemes:

```
App Clip Screen              Full App Screen
┌─────────────────┐         ┌─────────────────┐
│ Pre-Screening   │         │   QuickRent     │
├─────────────────┤         ├─────────────────┤
│ Property: APT101│         │ Total Pending...│
│                 │         │                 │
│ Move-in date? * │         │ Recent Apps     │
│ [Date Picker]   │         │                 │
│                 │         │ 🟠 apt101       │
│ Income?      *  │         │ john@email.com  │
│ [Text Field]    │         │ $6,000 2 people │
│                 │         │                 │
│ ... (4 more)    │         │ 🟠 apt202       │
│                 │         │ 555-123-4567    │
│ [Submit]        │         │ $7,500 3 people │
└─────────────────┘         └─────────────────┘
  Tenant (no DL)            Landlord (download)
```

---

**Need help?** See [TARGET_CONFIGURATION_CHECKLIST.md](TARGET_CONFIGURATION_CHECKLIST.md) for detailed troubleshooting.

**Next:** Configure landlord email in `QuestionnaireViewModel.swift` 📧
