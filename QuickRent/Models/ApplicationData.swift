//
//  ApplicationData.swift
//  QuickRent
//
//  Model for encoding/decoding tenant application data via Universal Links
//

import Foundation

struct ApplicationData: Codable, Identifiable {
    let id: UUID
    let propertyId: String
    let timestamp: Date
    let applicantName: String?
    let responses: [String: String]
    
    init(propertyId: String, timestamp: Date = Date(), applicantName: String? = nil, responses: [String: String]) {
        self.id = UUID()
        self.propertyId = propertyId
        self.timestamp = timestamp
        self.applicantName = applicantName
        self.responses = responses
    }
    
    // MARK: - Base64 Encoding/Decoding
    
    /// Convert application data to Base64-encoded string for Universal Link
    func toBase64() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let jsonData = try? encoder.encode(self) else {
            print("❌ Failed to encode ApplicationData to JSON")
            return nil
        }
        
        let base64String = jsonData.base64EncodedString()
        print("✅ Encoded application data: \(base64String.prefix(50))...")
        return base64String
    }
    
    /// Decode Base64 string back to ApplicationData
    static func fromBase64(_ base64String: String) -> ApplicationData? {
        guard let data = Data(base64Encoded: base64String) else {
            print("❌ Failed to decode Base64 string")
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let applicationData = try? decoder.decode(ApplicationData.self, from: data) else {
            print("❌ Failed to decode JSON from Base64")
            return nil
        }
        
        print("✅ Decoded application data for property: \(applicationData.propertyId)")
        return applicationData
    }
    
    // MARK: - Universal Link Generation
    
    /// Generate Universal Link with encoded data
    func generateUniversalLink() -> String? {
        guard let base64Data = toBase64() else { return nil }
        
        // URL encode the Base64 string to handle special characters
        guard let encodedData = base64Data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        return "https://quickrent.app/application?data=\(encodedData)"
    }
    
    /// Parse Universal Link to extract ApplicationData
    static func parseUniversalLink(_ url: URL) -> ApplicationData? {
        // Validate URL structure
        guard url.scheme == "https",
              url.host == "quickrent.app",
              url.path == "/application" else {
            print("❌ Invalid Universal Link format")
            return nil
        }
        
        // Extract query parameters
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let encodedData = queryItems.first(where: { $0.name == "data" })?.value else {
            print("❌ No data parameter found in Universal Link")
            return nil
        }
        
        // Decode URL encoding, then Base64
        guard let base64Data = encodedData.removingPercentEncoding else {
            print("❌ Failed to decode URL encoding")
            return nil
        }
        
        return fromBase64(base64Data)
    }
    
    // MARK: - SMS Message Generation
    
    /// Generate SMS message body with Universal Link
    func generateSMSMessage() -> String? {
        guard let link = generateUniversalLink() else { return nil }
        
        let propertyName = propertyId.isEmpty ? "this property" : propertyId
        
        return """
        Hi! I'm interested in \(propertyName). Here's my pre-screening application:
        
        \(link)
        
        Tap to view in QuickRent app!
        """
    }
    
    // MARK: - Formatted Display
    
    /// Get formatted response value with label
    func formattedResponse(for key: String) -> String {
        return responses[key] ?? "N/A"
    }
    
    /// Get all responses as formatted string for display
    func formattedSummary() -> String {
        var summary = "Property: \(propertyId)\n"
        summary += "Submitted: \(timestamp.formatted(date: .abbreviated, time: .shortened))\n\n"
        
        if let name = applicantName, !name.isEmpty {
            summary += "Applicant: \(name)\n\n"
        }
        
        summary += "Responses:\n"
        for (key, value) in responses.sorted(by: { $0.key < $1.key }) {
            summary += "- \(key.capitalized): \(value)\n"
        }
        
        return summary
    }
}

// MARK: - Preview Data

extension ApplicationData {
    static let sample = ApplicationData(
        propertyId: "apt101",
        timestamp: Date(),
        applicantName: "John Doe",
        responses: [
            "movein": "March 1, 2026",
            "income": "6000",
            "occupants": "3",
            "pets": "No",
            "smoking": "No",
            "contact": "555-123-4567"
        ]
    )
    
    static let sample2 = ApplicationData(
        propertyId: "apt202",
        timestamp: Date().addingTimeInterval(-3600),
        applicantName: "Jane Smith",
        responses: [
            "movein": "April 15, 2026",
            "income": "7500",
            "occupants": "2",
            "pets": "Yes - 1 cat",
            "smoking": "No",
            "contact": "jane@email.com"
        ]
    )
}
