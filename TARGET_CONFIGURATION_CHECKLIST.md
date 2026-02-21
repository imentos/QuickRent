# QuickRent Target Configuration - Action Items

## ✅ Files Already Created

All necessary files exist. Now we need to configure target membership.

---

## 🎯 Target Membership Configuration

### Step 1: Configure App Clip Entry Point (Already Done ✅)

The `QuickRentClipApp.swift` has been updated to show the questionnaire.

---

### Step 2: Delete Unnecessary App Clip Files

In Xcode, **delete** these files from the QuickRentClip folder:
- ❌ `QuickRentClip/ContentView.swift` (we don't need this, using QuestionnaireView instead)

**How to delete:**
1. In Xcode Navigator, find `QuickRentClip/ContentView.swift`
2. Right-click → Delete
3. Select "Move to Trash"

---

### Step 3: Configure Target Membership for Each File

Open Xcode and for each file below, follow these steps:
1. **Select the file** in Project Navigator (left sidebar)
2. **Open File Inspector** (right sidebar, or ⌥⌘1)
3. **Check/Uncheck** the Target Membership checkboxes as shown below

---

## 📋 Target Membership Checklist

### App Entry Points
| File | QuickRent (Full App) | QuickRentClip (App Clip) |
|------|---------------------|-------------------------|
| `QuickRent/QuickRentApp.swift` | ✅ CHECK | ❌ UNCHECK |
| `QuickRentClip/QuickRentClipApp.swift` | ❌ UNCHECK | ✅ CHECK |

### Main Views
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/ContentView.swift` | ✅ CHECK | ❌ UNCHECK |

### Shared Models (Both targets need these)
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/Models/Question.swift` | ✅ CHECK | ✅ CHECK |

### Shared ViewModels (Both targets need this)
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/ViewModels/QuestionnaireViewModel.swift` | ✅ CHECK | ✅ CHECK |

### Landlord ViewModels (Full App ONLY)
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/ViewModels/LandlordDashboardViewModel.swift` | ✅ CHECK | ❌ UNCHECK |

### Tenant Views (App Clip ONLY)
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/Views/QuestionnaireView.swift` | ❌ UNCHECK | ✅ CHECK |
| `QuickRent/Views/QuestionRowView.swift` | ❌ UNCHECK | ✅ CHECK |
| `QuickRent/Views/EmailComposerView.swift` | ❌ UNCHECK | ✅ CHECK |
| `QuickRent/Views/ConfirmationView.swift` | ❌ UNCHECK | ✅ CHECK |

### Landlord Views (Full App ONLY)
| File | QuickRent | QuickRentClip |
|------|-----------|---------------|
| `QuickRent/Views/Landlord/LandlordDashboardView.swift` | ✅ CHECK | ❌ UNCHECK |
| `QuickRent/Views/Landlord/ApplicationDetailView.swift` | ✅ CHECK | ❌ UNCHECK |

---

## 🚀 Step 4: Build and Test

### Test App Clip (QuickRentClip)

1. **Select App Clip scheme:**
   - Xcode toolbar → Scheme dropdown → **QuickRentClip**

2. **Select destination:**
   - Choose your iPhone or simulator

3. **Build and Run:**
   - Press ⌘R or click the Play button
   - App Clip should launch showing the questionnaire

4. **Expected Result:**
   - ✅ Shows "Pre-Screening Application" screen
   - ✅ Shows property ID "apt101"
   - ✅ Shows 6 questions
   - ✅ Can fill out form
   - ✅ Submit button works
   - ✅ Email composer opens

5. **Test URL handling (Optional):**
   - Product → Scheme → Edit Scheme
   - Run → Arguments tab
   - Environment Variables → Add:
     - Name: `_XCAppClipURL`
     - Value: `https://quickrent.app/property?id=test123`
   - Run again and check console for: "📍 App Clip launched for property: test123"

### Test Full App (QuickRent)

1. **Select Full App scheme:**
   - Xcode toolbar → Scheme dropdown → **QuickRent**

2. **Build and Run:**
   - Press ⌘R

3. **Expected Result:**
   - ✅ Shows "QuickRent" navigation title
   - ✅ Shows dashboard with stats cards
   - ✅ Shows "Recent Applications" section
   - ✅ Shows 2 sample applications
   - ✅ Can tap application to see details
   - ✅ Shows tenant information (income, occupants, etc.)
   - ✅ Shows Approve/Reject buttons

---

## 🐛 Troubleshooting

### Error: "Cannot find 'QuestionnaireView' in scope" (in App Clip)
**Solution:**
- Open `QuickRent/Views/QuestionnaireView.swift`
- File Inspector → Target Membership
- ✅ Check **QuickRentClip**

### Error: "Cannot find 'LandlordDashboardView' in scope" (in Full App)
**Solution:**
- This is correct if it's in the App Clip!
- Make sure `LandlordDashboardView.swift` has:
  - ✅ QuickRent checked
  - ❌ QuickRentClip unchecked

### Error: "Duplicate symbol 'ContentView'"
**Solution:**
- Delete `QuickRentClip/ContentView.swift` (Xcode's default file)
- We're using QuestionnaireView instead

### App Clip shows "Hello, world!"
**Solution:**
- Make sure `QuickRentClipApp.swift` was updated (should show QuestionnaireView)
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Build again

### Full App shows questionnaire instead of dashboard
**Solution:**
- Check `QuickRent/ContentView.swift` target membership
- Should have ✅ QuickRent, ❌ QuickRentClip
- Make sure it shows `LandlordDashboardView()` in body

---

## 📱 Quick Visual Check

After configuration, you should have:

**When running QuickRentClip scheme:**
```
┌─────────────────────────────┐
│ Pre-Screening Application   │
├─────────────────────────────┤
│ Property: APT101            │
│                             │
│ Desired move-in date?  *    │
│ [Date Picker]               │
│                             │
│ Monthly household income? * │
│ [Text Field]                │
│                             │
│ ... (4 more questions)      │
│                             │
│ [Submit Pre-Screen]         │
└─────────────────────────────┘
```

**When running QuickRent scheme:**
```
┌─────────────────────────────┐
│          QuickRent          │
├─────────────────────────────┤
│ [Total: 2] [Pending: 2] ... │
│                             │
│ Recent Applications         │
│                             │
│ 🟠 apt101                   │
│    john@example.com         │
│    $6,000 | 2 people        │
│                             │
│ 🟠 apt202                   │
│    555-123-4567             │
│    $7,500 | 3 people        │
└─────────────────────────────┘
```

---

## ✅ Final Verification

Once everything is configured:

- [ ] App Clip builds without errors
- [ ] App Clip shows questionnaire (not "Hello, world!")
- [ ] Full App builds without errors  
- [ ] Full App shows landlord dashboard (not questionnaire)
- [ ] Both schemes run independently
- [ ] No duplicate symbol errors
- [ ] File sizes reasonable (App Clip < 10MB uncompressed ~3MB)

---

## 🎉 Next Steps After Configuration

Once both targets build successfully:

1. **Configure Landlord Email:**
   - Edit `QuestionnaireViewModel.swift`
   - Update `landlordEmail = "your-email@example.com"`

2. **Test Email Submission:**
   - Run App Clip on physical device
   - Fill questionnaire
   - Submit and verify email arrives

3. **Customize Questions (Optional):**
   - Edit `Question.swift` → `Questionnaire.sample`
   - Add/remove/modify questions

4. **Production Setup (Later):**
   - Set up domain and AASA file
   - Configure App Store Connect
   - Generate QR codes
   - Submit to App Store

---

## 📞 Need Help?

If you encounter issues:

1. **Check Build Errors:**
   - Read the error message carefully
   - Usually indicates missing target membership

2. **Clean Build:**
   - Product → Clean Build Folder (⇧⌘K)
   - Try building again

3. **Verify File Membership:**
   - Double-check the table above
   - Each file should have correct targets

4. **Check Console Output:**
   - Look for print statements
   - "📍 App Clip launched for property: ..." indicates URL handling works

---

**Ready to configure?** Start with Step 2 (delete ContentView.swift), then Step 3 (configure target membership for each file). Let me know if you hit any errors! 🚀
