//
//  QuestionRowView.swift
//  QuickRent
//
//  Individual question input view
//

import SwiftUI

struct QuestionRowView: View {
    let question: Question
    @Binding var response: Response
    let hasError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Question text with required indicator
            HStack(spacing: 4) {
                Text(question.text)
                    .font(.body)
                    .fontWeight(.medium)
                
                if question.required {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            // Input based on question type
            switch question.type {
            case .text:
                TextField("Your answer", text: $response.textValue)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)
                
            case .number:
                TextField("Amount", text: $response.numberValue)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                
            case .yesNo:
                HStack(spacing: 16) {
                    Button(action: {
                        response.boolValue = true
                    }) {
                        HStack {
                            Image(systemName: response.boolValue == true ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(response.boolValue == true ? .green : .gray)
                            Text("Yes")
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(response.boolValue == true ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        response.boolValue = false
                    }) {
                        HStack {
                            Image(systemName: response.boolValue == false ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(response.boolValue == false ? .red : .gray)
                            Text("No")
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(response.boolValue == false ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
            case .date:
                DatePicker("Select date", selection: Binding(
                    get: { response.dateValue ?? Date() },
                    set: { response.dateValue = $0 }
                ), displayedComponents: .date)
                .datePickerStyle(.compact)
            }
            
            // Error message
            if hasError {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    QuestionRowView(
        question: Question(id: "test", text: "Sample question?", type: .text, required: true),
        response: .constant(Response(id: "test")),
        hasError: false
    )
    .padding()
}
