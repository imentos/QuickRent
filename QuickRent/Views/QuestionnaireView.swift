//
//  QuestionnaireView.swift
//  QuickRent
//
//  Main questionnaire view for pre-screening
//

import SwiftUI
import MessageUI

struct QuestionnaireView: View {
    let landlordPhone: String?
    let propertyId: String?
    
    @StateObject private var viewModel: QuestionnaireViewModel
    
    init(landlordPhone: String? = nil, propertyId: String? = nil) {
        self.landlordPhone = landlordPhone
        self.propertyId = propertyId
        
        // Initialize view model with parameters
        _viewModel = StateObject(wrappedValue: QuestionnaireViewModel(
            landlordPhone: landlordPhone ?? "+1234567890",
            propertyId: propertyId
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        if let propertyId = viewModel.questionnaire.propertyId {
                            Text("Property: \(propertyId.uppercased())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(viewModel.questionnaire.title)
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Please answer the following questions to proceed with your rental application.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 8)
                    
                    // Questions
                    ForEach(viewModel.questionnaire.questions) { question in
                        QuestionRowView(
                            question: question,
                            response: Binding(
                                get: { viewModel.responses[question.id] ?? Response(id: question.id) },
                                set: { viewModel.responses[question.id] = $0 }
                            ),
                            hasError: viewModel.validationErrors.contains(question.id)
                        )
                        
                        Divider()
                    }
                    
                    // Privacy notice
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.blue)
                            Text("Your information is private and will only be shared with the property landlord.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)
                    }
                    
                    // Submit buttons
                    VStack(spacing: 12) {
                        // Primary: SMS with Universal Link
                        Button(action: {
                            viewModel.submitViaSMS()
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Send via SMS")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        // Secondary: Email fallback
                        Button(action: {
                            viewModel.submitViaEmail()
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("Send via Email")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Help") {
                        // Show help info
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingSubmission) {
                EmailComposerView(
                    recipients: [viewModel.landlordEmail],
                    subject: viewModel.getEmailSubject(),
                    body: viewModel.generateEmailBody(),
                    onDismiss: {
                        viewModel.confirmSubmission()
                    }
                )
            }
            .sheet(isPresented: $viewModel.showingSMSSubmission) {
                if MFMessageComposeViewController.canSendText(),
                   let messageBody = viewModel.generateSMSMessageBody() {
                    SMSComposerView(
                        recipients: [viewModel.landlordPhone],
                        body: messageBody,
                        onDismiss: {
                            viewModel.confirmSubmission()
                        }
                    )
                } else {
                    SMSUnavailableView(
                        isPresented: $viewModel.showingSMSSubmission,
                        recipients: [viewModel.landlordPhone],
                        messageBody: viewModel.generateSMSMessageBody() ?? "",
                        universalLink: viewModel.generatedUniversalLink
                    )
                }
            }
            .sheet(isPresented: $viewModel.showingConfirmation) {
                ConfirmationView()
            }
        }
    }
}

#Preview {
    QuestionnaireView()
}
