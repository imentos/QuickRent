//
//  Question.swift
//  QuickRent
//
//  Data models for tenant pre-screening questionnaire
//

import Foundation

enum QuestionType: String, Codable {
    case text
    case number
    case yesNo = "yes_no"
    case date
}

struct Question: Identifiable, Codable {
    let id: String
    let text: String
    let type: QuestionType
    let required: Bool
}

struct Questionnaire: Codable {
    let propertyId: String?
    let title: String
    let questions: [Question]
    
    // Sample questionnaire for testing
    static let sample = Questionnaire(
        propertyId: "apt101",
        title: "Pre-Screening Application",
        questions: [
            Question(id: "movein", text: "Desired move-in date?", type: .date, required: true),
            Question(id: "income", text: "Monthly household income?", type: .number, required: true),
            Question(id: "occupants", text: "Number of adults and children?", type: .number, required: true),
            Question(id: "pets", text: "Any pets?", type: .yesNo, required: true),
            Question(id: "smoking", text: "Do you smoke?", type: .yesNo, required: false),
            Question(id: "contact", text: "Phone number or email?", type: .text, required: true)
        ]
    )
}

struct Response {
    let id: String
    var textValue: String = ""
    var numberValue: String = ""
    var boolValue: Bool? = nil
    var dateValue: Date? = nil
    
    var isEmpty: Bool {
        switch textValue.isEmpty {
        case true where numberValue.isEmpty && boolValue == nil && dateValue == nil:
            return true
        default:
            return false
        }
    }
    
    func formattedAnswer(for type: QuestionType) -> String {
        switch type {
        case .text:
            return textValue
        case .number:
            return numberValue
        case .yesNo:
            return boolValue == true ? "Yes" : boolValue == false ? "No" : ""
        case .date:
            if let date = dateValue {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: date)
            }
            return ""
        }
    }
}
