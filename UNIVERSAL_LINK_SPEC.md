# QuickRent Universal Link Architecture

## Overview

QuickRent uses **Universal Links with Base64-encoded JSON** to transfer application data from tenants to landlords without requiring a backend server.

---

## Architecture Flow

```
[Tenant fills App Clip questionnaire]
           ↓
[App generates Base64-encoded link]
           ↓
[Opens SMS composer with link]
           ↓
[Tenant sends SMS to landlord]
           ↓
[Landlord taps link]
           ↓
[Full App opens and decodes data]
           ↓
[Application displayed in dashboard]
```

---

## Universal Link Format

### Link Structure
```
https://quickrent.app/application?data=BASE64_ENCODED_JSON
```

### Decoded JSON Structure
```json
{
  "propertyId": "apt101",
  "timestamp": "2026-02-21T15:30:00Z",
  "applicantName": "John Doe",
  "responses": {
    "movein": "March 1, 2026",
    "income": "6000",
    "occupants": "3",
    "pets": "No",
    "smoking": "No",
    "contact": "555-123-4567"
  }
}
```

### Example Base64 Encoding
**Original JSON:**
```json
{"propertyId":"apt101","timestamp":"2026-02-21T15:30:00Z","responses":{"movein":"March 1, 2026","income":"6000","occupants":"3","pets":"No","smoking":"No","contact":"555-123-4567"}}
```

**Base64 Encoded:**
```
eyJwcm9wZXJ0eUlkIjoiYXB0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIzIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6IjU1NS0xMjMtNDU2NyJ9fQ==
```

**Final Link:**
```
https://quickrent.app/application?data=eyJwcm9wZXJ0eUlkIjoiYXB0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIzIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6IjU1NS0xMjMtNDU2NyJ9fQ==
```

---

## SMS Message Template

```text
Hi! I'm interested in [Property Name]. Here's my application:

https://quickrent.app/application?data=[BASE64_DATA]

Tap to view in QuickRent app!
```

### Example SMS
```text
Hi! I'm interested in Apt 101. Here's my application:

https://quickrent.app/application?data=eyJwcm9wZXJ0eUlkIjoiYXB0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIzIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6IjU1NS0xMjMtNDU2NyJ9fQ==

Tap to view in QuickRent app!
```

---

## Implementation Components

### 1. Application Data Model
```swift
struct ApplicationData: Codable {
    let propertyId: String
    let timestamp: Date
    let applicantName: String?
    let responses: [String: String]
    
    // Convert to Base64 encoded string
    func toBase64() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return jsonData.base64EncodedString()
    }
    
    // Decode from Base64 string
    static func fromBase64(_ base64String: String) -> ApplicationData? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(ApplicationData.self, from: data)
    }
}
```

### 2. Link Generator (Tenant Side)
```swift
extension QuestionnaireViewModel {
    func generateUniversalLink() -> String? {
        let applicationData = ApplicationData(
            propertyId: questionnaire.propertyId ?? "unknown",
            timestamp: Date(),
            applicantName: nil,
            responses: formatResponsesForEncoding()
        )
        
        guard let base64Data = applicationData.toBase64() else { return nil }
        return "https://quickrent.app/application?data=\(base64Data)"
    }
    
    func generateSMSMessage(landlordPhone: String) -> String {
        guard let link = generateUniversalLink() else { return "" }
        let propertyName = questionnaire.propertyId ?? "this property"
        
        return """
        Hi! I'm interested in \(propertyName). Here's my application:
        
        \(link)
        
        Tap to view in QuickRent app!
        """
    }
}
```

### 3. URL Handler (Landlord Side)
```swift
// In QuickRentApp.swift
.onOpenURL { url in
    handleUniversalLink(url)
}

func handleUniversalLink(_ url: URL) {
    guard url.host == "quickrent.app",
          url.path == "/application",
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems,
          let base64Data = queryItems.first(where: { $0.name == "data" })?.value,
          let applicationData = ApplicationData.fromBase64(base64Data) else {
        return
    }
    
    // Import application into dashboard
    landlordViewModel.importApplication(applicationData)
}
```

### 4. SMS Composer Integration
```swift
import MessageUI

func sendApplicationViaSMS(to phoneNumber: String) {
    guard MFMessageComposeViewController.canSendText() else {
        print("SMS not available")
        return
    }
    
    let message = generateSMSMessage(landlordPhone: phoneNumber)
    
    let composer = MFMessageComposeViewController()
    composer.recipients = [phoneNumber]
    composer.body = message
    composer.messageComposeDelegate = self
    
    present(composer, animated: true)
}
```

---

## Advantages

✅ **No Backend Required**
- Zero server costs
- No database needed
- No API endpoints to maintain

✅ **Instant Transfer**
- Data is in the link itself
- Works offline (after generation)
- No network latency

✅ **Privacy Friendly**
- Data goes directly to landlord
- No third-party storage
- No tracking

✅ **Simple Architecture**
- Easy to implement
- Easy to debug
- Easy to maintain

✅ **Flexible Sharing**
- SMS (primary method)
- Email (fallback)
- Any messaging app
- Copy/paste

---

## URL Size Considerations

### Typical Application Size
- JSON: ~300-500 bytes
- Base64 encoded: ~400-700 bytes
- Full URL: ~450-750 bytes

### iOS URL Limits
- SMS: 1600 characters (safe)
- Universal Links: No practical limit
- Safari: 2048+ characters (safe)

**Conclusion:** Our URLs are well within safe limits.

---

## Security Considerations

### Data Privacy
- Links contain tenant data in plain text (Base64 is encoding, not encryption)
- Only share links through secure channels (SMS)
- Add expiration timestamp if needed
- Consider HTTPS encryption in transit

### Optional Enhancements (Future)
- Add checksum/signature to prevent tampering
- Add expiration timestamp
- Encrypt data before Base64 encoding
- Use shortened URLs with server redirect (requires backend)

---

## Testing

### Test Link Generation
```swift
let testData = ApplicationData(
    propertyId: "apt101",
    timestamp: Date(),
    applicantName: "Test User",
    responses: [
        "movein": "March 1, 2026",
        "income": "6000",
        "occupants": "3",
        "pets": "No",
        "smoking": "No",
        "contact": "555-123-4567"
    ]
)

let link = testData.toBase64()
print("Generated link: https://quickrent.app/application?data=\(link)")
```

### Test Link Parsing
```swift
let testLink = "https://quickrent.app/application?data=eyJwcm9wZXJ0eUlkIjoiYXB0MTAxIiwidGltZXN0YW1wIjoiMjAyNi0wMi0yMVQxNTozMDowMFoiLCJyZXNwb25zZXMiOnsibW92ZWluIjoiTWFyY2ggMSwgMjAyNiIsImluY29tZSI6IjYwMDAiLCJvY2N1cGFudHMiOiIzIiwicGV0cyI6Ik5vIiwic21va2luZyI6Ik5vIiwiY29udGFjdCI6IjU1NS0xMjMtNDU2NyJ9fQ=="

if let url = URL(string: testLink),
   let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
   let queryItems = components.queryItems,
   let base64Data = queryItems.first(where: { $0.name == "data" })?.value,
   let applicationData = ApplicationData.fromBase64(base64Data) {
    print("Decoded successfully!")
    print("Property: \(applicationData.propertyId)")
    print("Responses: \(applicationData.responses)")
}
```

---

## Implementation Checklist

- [ ] Create `ApplicationData` model with Base64 encoding/decoding
- [ ] Add link generation to `QuestionnaireViewModel`
- [ ] Implement SMS composer with generated link
- [ ] Add Universal Link handling in `QuickRentApp`
- [ ] Update landlord dashboard to receive imported applications
- [ ] Add confirmation screen showing sent message
- [ ] Test end-to-end flow
- [ ] Add error handling for malformed links
- [ ] Update UI to show "Send via SMS" button
- [ ] Add landlord phone number configuration

---

## Future Enhancements

### Phase 2
- QR code generation from link
- Link expiration (optional)
- Multi-property support
- Application history tracking

### Phase 3
- End-to-end encryption
- Digital signatures
- Link analytics
- Batch import

---

**Status:** Ready for implementation
**Last Updated:** February 21, 2026
