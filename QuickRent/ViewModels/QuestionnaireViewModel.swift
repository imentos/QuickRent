//
//  QuestionnaireViewModel.swift
//  QuickRent
//
//  ViewModel for managing questionnaire state and submission
//

import Foundation
import MessageUI
import Combine

@MainActor
class QuestionnaireViewModel: ObservableObject {
    @Published var questionnaire: Questionnaire
    @Published var responses: [String: Response] = [:]
    @Published var showingSubmission = false
    @Published var showingSMSSubmission = false
    @Published var showingConfirmation = false
    @Published var validationErrors: Set<String> = []
    @Published var generatedUniversalLink: String?
    
    let landlordEmail: String
    let landlordPhone: String
    
    init(questionnaire: Questionnaire = .sample, landlordPhone: String = "+1234567890", propertyId: String? = nil) {
        // Update questionnaire with property ID if provided
        var updatedQuestionnaire = questionnaire
        if let propertyId = propertyId {
            updatedQuestionnaire.propertyId = propertyId
        }
        self.questionnaire = updatedQuestionnaire
        
        // Configure contact info
        self.landlordPhone = landlordPhone
        self.landlordEmail = "landlord@email.com" // Can be extended to accept as parameter
        
        // Initialize responses for all questions
        for question in questionnaire.questions {
            responses[question.id] = Response(id: question.id)
        }
    }
    
    // MARK: - Validation
    
    func validateResponses() -> Bool {
        validationErrors.removeAll()
        
        for question in questionnaire.questions {
            guard question.required else { continue }
            
            guard let response = responses[question.id] else {
                validationErrors.insert(question.id)
                continue
            }
            
            // Check if response is empty based on question type
            let isEmpty: Bool
            switch question.type {
            case .text:
                isEmpty = response.textValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .number:
                isEmpty = response.numberValue.isEmpty
            case .yesNo:
                isEmpty = response.boolValue == nil
            case .date:
                isEmpty = response.dateValue == nil
            }
            
            if isEmpty {
                validationErrors.insert(question.id)
            }
        }
        
        return validationErrors.isEmpty
    }
    
    // MARK: - Universal Link Generation (NEW)
    
    /// Format responses as string dictionary for ApplicationData
    private func formatResponsesForEncoding() -> [String: String] {
        var formatted: [String: String] = [:]
        
        for question in questionnaire.questions {
            guard let response = responses[question.id] else { continue }
            let answer = response.formattedAnswer(for: question.type)
            if !answer.isEmpty {
                formatted[question.id] = answer
            }
        }
        
        return formatted
    }
    
    /// Generate ApplicationData with current responses
    func generateApplicationData() -> ApplicationData {
        return ApplicationData(
            propertyId: questionnaire.propertyId ?? "unknown",
            timestamp: Date(),
            applicantName: nil,
            responses: formatResponsesForEncoding()
        )
    }
    
    /// Generate Universal Link with encoded data
    func generateUniversalLink() -> String? {
        let applicationData = generateApplicationData()
        let link = applicationData.generateUniversalLink()
        generatedUniversalLink = link
        return link
    }
    
    /// Generate SMS message body with Universal Link
    func generateSMSMessageBody() -> String? {
        let applicationData = generateApplicationData()
        return applicationData.generateSMSMessage()
    }
    
    // MARK: - Email Generation
    
    func generateEmailBody() -> String {
        let timestamp = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        var body = "Applicant Responses:\n\n"
        
        for question in questionnaire.questions {
            guard let response = responses[question.id] else { continue }
            let answer = response.formattedAnswer(for: question.type)
            if !answer.isEmpty {
                body += "- \(question.text) \(answer)\n"
            }
        }
        
        body += "\n"
        if let propertyId = questionnaire.propertyId {
            body += "Property: \(propertyId)\n"
        }
        body += "Timestamp: \(formatter.string(from: timestamp))\n"
        
        return body
    }
    
    func getEmailSubject() -> String {
        if let propertyId = questionnaire.propertyId {
            return "Rental Pre-Screen – \(propertyId)"
        }
        return "Rental Pre-Screen Application"
    }
    
    // MARK: - Actions
    
    func submitViaSMS() {
        guard validateResponses() else { return }
        
        // Check if SMS is available
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS not available on this device")
            return
        }
        
        // Generate the Universal Link
        guard generateUniversalLink() != nil else {
            print("Failed to generate Universal Link")
            return
        }
        
        showingSMSSubmission = true
    }
    
    func submitViaEmail() {
        guard validateResponses() else { return }
        
        // Check if email is available
        guard MFMailComposeViewController.canSendMail() else {
            // Show error - email not configured
            print("Email not available on this device")
            return
        }
        
        showingSubmission = true
    }
    
    func confirmSubmission() {
        showingSubmission = false
        showingSMSSubmission = false
        showingConfirmation = true
    }
}
