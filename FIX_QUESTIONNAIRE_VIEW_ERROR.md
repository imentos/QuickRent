# Fix: Cannot find 'QuestionnaireView' in scope

## Problem
```
QuickRentClipApp.swift:16:13 Cannot find 'QuestionnaireView' in scope
```

This means the QuestionnaireView.swift file isn't included in the QuickRentClip target.

---

## ⚡ Quick Fix (2 minutes)

### Step 1: Add QuestionnaireView to App Clip Target

**In Xcode:**

1. **Select the file** in Project Navigator (left sidebar):
   - Navigate to: `QuickRent` → `Views` → `QuestionnaireView.swift`
   - Click on the file to select it

2. **Open File Inspector** (right sidebar):
   - If not visible: View → Inspectors → File (or press ⌥⌘1)
   - Look for "Target Membership" section

3. **Check the QuickRentClip checkbox:**
   ```
   Target Membership:
   ❌ QuickRent         ← UNCHECK this
   ✅ QuickRentClip     ← CHECK this
   ```

4. **Clean and Build:**
   - Product → Clean Build Folder (⇧⌘K)
   - Product → Build (⌘B)

### Step 2: Add Related Files to App Clip Target

While you're at it, add these files too (same process):

**Files that need QuickRentClip target:**

1. **QuestionRowView.swift**
   - Location: `QuickRent/Views/QuestionRowView.swift`
   - Target: ❌ QuickRent, ✅ QuickRentClip

2. **EmailComposerView.swift**
   - Location: `QuickRent/Views/EmailComposerView.swift`
   - Target: ❌ QuickRent, ✅ QuickRentClip

3. **ConfirmationView.swift**
   - Location: `QuickRent/Views/ConfirmationView.swift`
   - Target: ❌ QuickRent, ✅ QuickRentClip

4. **Question.swift** (shared - needs BOTH targets)
   - Location: `QuickRent/Models/Question.swift`
   - Target: ✅ QuickRent, ✅ QuickRentClip

5. **QuestionnaireViewModel.swift** (shared - needs BOTH targets)
   - Location: `QuickRent/ViewModels/QuestionnaireViewModel.swift`
   - Target: ✅ QuickRent, ✅ QuickRentClip

---

## 📋 Complete Target Membership Checklist

### App Clip Target (QuickRentClip) - Check These:

```
✅ Models/Question.swift
✅ ViewModels/QuestionnaireViewModel.swift
✅ Views/QuestionnaireView.swift
✅ Views/QuestionRowView.swift
✅ Views/EmailComposerView.swift
✅ Views/ConfirmationView.swift
✅ QuickRentClip/QuickRentClipApp.swift
```

### Full App Target (QuickRent) - Check These:

```
✅ Models/Question.swift
✅ ViewModels/QuestionnaireViewModel.swift
✅ ViewModels/LandlordDashboardViewModel.swift
✅ Views/Landlord/LandlordDashboardView.swift
✅ Views/Landlord/ApplicationDetailView.swift
✅ ContentView.swift
✅ QuickRentApp.swift
```

---

## 🎯 Visual Guide

**Where to find Target Membership:**

```
Xcode Window Layout:

┌──────────────────────────────────────────────────────────┐
│ Toolbar                                                  │
├─────────────┬───────────────────────────┬────────────────┤
│             │                           │                │
│  Navigator  │     Editor Area          │  Inspector     │
│             │                           │                │
│  📁 Project │  Code appears here       │ TARGET MEMBERSHIP:
│  📄 Files   │                           │ ☐ QuickRent    │
│             │                           │ ☐ QuickRentClip│
│   Click on  │                           │     ↑          │
│   a file →  │                           │  Check these!  │
│             │                           │                │
└─────────────┴───────────────────────────┴────────────────┘
                                           ↑
                                    Right sidebar
                              (File Inspector ⌥⌘1)
```

---

## ⚠️ Common Mistakes

### ❌ Wrong: Both targets checked for QuestionnaireView
```
QuestionnaireView.swift
Target Membership:
✅ QuickRent        ← DON'T check this
✅ QuickRentClip    ← Only this one
```

**Why wrong?** The Full App (QuickRent) should show the dashboard, not the questionnaire.

### ✅ Correct: Only App Clip checked
```
QuestionnaireView.swift
Target Membership:
❌ QuickRent        ← Unchecked
✅ QuickRentClip    ← Checked
```

---

## 🧪 Test After Fixing

### Test App Clip:
1. Select **QuickRentClip** scheme
2. Run (⌘R)
3. Should see questionnaire ✅
4. Should NOT see "Cannot find QuestionnaireView" error ✅

### Test Full App:
1. Select **QuickRent** scheme
2. Run (⌘R)
3. Should see dashboard ✅
4. Should NOT have questionnaire views ✅

---

## 🔍 Troubleshooting

### Still getting the error?

**Check 1:** Did you clean build folder?
- Product → Clean Build Folder (⇧⌘K)

**Check 2:** Is the file in the correct location?
- File should be at: `QuickRent/Views/QuestionnaireView.swift`
- Not in: `QuickRentClip/` folder

**Check 3:** Are you building the correct scheme?
- Top left dropdown should show: **QuickRentClip**
- Not: QuickRent

**Check 4:** Did you check AND save?
- After checking the box, click elsewhere to ensure it saves
- Look for the checkmark to persist

### Other errors appearing?

If you get errors for other files (QuestionRowView, EmailComposerView, etc.):
- Follow the same process
- Add each file to the QuickRentClip target

---

## 🎉 Success Looks Like

After fixing target membership and building:

```
✅ Build Succeeded
✅ QuickRentClip scheme runs
✅ Shows questionnaire with 6 questions
✅ No "Cannot find..." errors
```

---

## 📞 Quick Reference

**To add a file to a target:**
1. Select file in Navigator (left)
2. File Inspector (right, ⌥⌘1)
3. Target Membership → Check box
4. Clean Build (⇧⌘K)
5. Build (⌘B)

**Files for App Clip:**
- QuestionnaireView ✅
- QuestionRowView ✅
- EmailComposerView ✅
- ConfirmationView ✅
- Question.swift ✅
- QuestionnaireViewModel ✅

That's it! The error should be gone. 🚀
