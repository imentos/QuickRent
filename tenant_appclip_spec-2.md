# Tenant Pre-Screening & Landlord-Only Full Application App Spec

## 1. Overview

This document specifies the workflow, features, and implementation plan for a **serverless App Clip pre-screening tool** for rental properties, with a **landlord-only full app**. Tenants **never download the app**; all interaction is through App Clip or email/SMS.

**Goals:**
- Enable tenants to quickly pre-screen for properties without downloading an app
- Provide instant tenant responses to the landlord
- Allow landlords to see and manage all applications in one full app
- Maintain a lean MVP with serverless or free solutions

---

## 2. User Roles

| Role       | Description                                   | Access / Actions |
|------------|-----------------------------------------------|-----------------|
| Tenant     | Prospective renter                             | Complete pre-screen via App Clip, submit responses, see confirmation screen |
| Landlord   | Property manager / wife                        | Full access to all applications, review, approve, reject, schedule viewings |
| Future Admin | Multi-landlord management (future)          | Manage properties, view applicants across landlords |

---

## 3. App Clip Pre-Screen Flow

### 3.1 Launch
- Tenant scans **QR code** or taps **deep link**
- App Clip opens
- Property ID passed via URL parameter (e.g., `?property=apt101`)

### 3.2 Questionnaire
- Short, essential questions (5–8)
- Types: `text`, `number`, `yes_no`, `date`
- Example JSON schema:

```json
{
  "title": "Pre-Screening",
  "questions": [
    { "id": "movein", "text": "Desired move-in date?", "type": "date", "required": true },
    { "id": "income", "text": "Monthly household income?", "type": "number", "required": true },
    { "id": "occupants", "text": "Number of adults and children?", "type": "number", "required": true },
    { "id": "pets", "text": "Any pets?", "type": "yes_no", "required": true },
    { "id": "smoking", "text": "Do you smoke?", "type": "yes_no", "required": false },
    { "id": "contact", "text": "Phone number or email?", "type": "text", "required": true }
  ]
}
```

### 3.3 Submission
- Tenant taps **Submit**
- App Clip opens **email or SMS composer** with pre-filled responses OR submits via serverless form
- Example email body:

```text
To: wife@email.com
Subject: Rental Pre-Screen – Apt 101

Applicant Responses:
- Move-in date: March 1, 2026
- Monthly income: $6,000
- Occupants: 2 adults, 1 child
- Pets: None
- Smoking: No
- Contact: 555-123-4567

Property: Apt 101
Timestamp: 2026-02-20 18:00
```

- **No server required** for MVP

### 3.4 Confirmation Screen
- Message: “✅ Thank you! Your pre-screen is submitted.”
- Optional action button for scheduling showing

---

## 4. Landlord-Only Full App Workflow

### 4.1 Receive Responses
- Tenant submissions arrive via email/SMS or serverless form
- Landlord opens **Full App** to see all applications

### 4.2 Full App Features

| Feature | Description |
|---------|-------------|
| **Dashboard** | Overview of all properties & applications |
| **Applicant List** | Sort/filter by property, move-in date, income, pets |
| **Application Details** | See tenant responses in full |
| **Decision Actions** | Approve, Reject, Request Clarification |
| **Scheduling** | Calendar integration to book showings |
| **Notes** | Landlord-only notes per applicant |
| **Search/Filter** | Quickly find tenants or properties |
| **Optional Export** | CSV / PDF for records |
| **Notifications** | Push/email when new applications arrive |

### 4.3 Advantages
1. **No app friction** – tenants never download the app
2. **Better security** – landlord handles sensitive info in full app
3. **Scalable** – manage multiple properties and tenants easily
4. **Serverless friendly MVP** – initial responses via email/SMS

---

## 5. Data & Hosting Strategy

### 5.1 App Clip Questions
- Host **JSON files on GitHub Pages / Cloudflare Pages**
- URL structure: `/questions/apt101.json`
- Free, serverless, public (safe for non-sensitive questions)

### 5.2 Responses
- Delivered via email or SMS to landlord
- Optional: free backends (Google Forms, Airtable, Tally) if more structure is needed
- No tenant login required

---

## 6. UX / Conversion Guidelines

- Keep App Clip **short & simple** (≤ 8 questions)
- Include **property identifier** in submissions
- Provide **clear confirmation** for tenant
- Avoid rejection messages at pre-screen stage (legal / fairness)

---

## 7. MVP Feature Scope

| Feature                                  | Phase |
|------------------------------------------|-------|
| App Clip pre-screen questionnaire         | 1     |
| Email/SMS submission                      | 1     |
| Landlord manual review / approval         | 1     |
| Full app dashboard and applicant management | 1   |
| Scheduling / calendar integration         | 2     |
| Notes and search/filter                   | 2     |
| Optional export / reporting               | 2     |
| Multi-landlord support                     | 3     |

---

## 8. Tech Stack Recommendation

| Component                | Technology / Tool                     | Notes |
|---------------------------|--------------------------------------|-------|
| App Clip (iOS)            | SwiftUI / UIKit                       | Pre-screen questionnaire + submission |
| Question hosting           | GitHub Pages / Cloudflare Pages       | Free JSON hosting |
| Response delivery          | Email or SMS (via App Clip composer)  | Serverless MVP |
| Full App (Landlord-only)   | SwiftUI / UIKit                        | Dashboard + application management |
| Optional backend           | Google Forms / Airtable / Tally       | For structured response collection |

---

## 9. Recommended Early Funnel

```text
[Tenant scans QR / taps App Clip]
           │
           ▼
[Pre-screen Questionnaire]
           │
           ▼
[Submit via Email / SMS]
           │
           ▼
[Confirmation Screen for Tenant]
           │
           ▼
[Landlord opens Full App → sees all applications]
           │
           ▼
[Review / Approve / Reject / Schedule Showing]
```

---

## 10. Visual Flow Diagram

```text
Tenant Journey:

[Scan QR / Tap Link]
          │
          ▼
     [App Clip Launch]
          │
          ▼
 [Pre-Screen Questionnaire]
          │
          ▼
 [Submit via Email / SMS]
          │
          ▼
 [Confirmation Screen]
          │
          ▼
  [Landlord-Only Full App]
          │
          ▼
[Dashboard → Review / Approve / Schedule Showing]
```

---

## 11. Legal & Compliance Considerations

- Avoid pre-screen rejection messages in App Clip  
- Collect minimal sensitive data at pre-screen stage  
- Document consent & fair housing disclaimer in full application  
- Encrypt / secure data in full application & document uploads

---

**End of Spec**

