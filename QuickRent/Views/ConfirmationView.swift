//
//  ConfirmationView.swift
//  QuickRent
//
//  Confirmation screen after submission
//

import SwiftUI

struct ConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                }
                .padding(.bottom, 8)
                
                // Success message
                VStack(spacing: 12) {
                    Text("Pre-Screen Submitted!")
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("Your responses have been sent to the landlord. They will review your information and contact you soon.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Next steps
                VStack(spacing: 16) {
                    Text("What's Next?")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        NextStepCard(
                            icon: "doc.text.fill",
                            title: "Complete Full Application",
                            description: "Provide additional details and documentation",
                            action: {
                                // Navigate to full app
                            }
                        )
                        
                        NextStepCard(
                            icon: "calendar",
                            title: "Schedule a Showing",
                            description: "Book a time to view the property in person",
                            action: {
                                // Navigate to scheduling
                            }
                        )
                        
                        NextStepCard(
                            icon: "message.fill",
                            title: "Contact Landlord",
                            description: "Ask questions or provide more information",
                            action: {
                                // Open messaging
                            }
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NextStepCard: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ConfirmationView()
}
