//
//  EmailComposerView.swift
//  QuickRent
//
//  Email composer wrapper for submission
//

import SwiftUI
import MessageUI

struct EmailComposerView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let body: String
    var onDismiss: () -> Void
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: EmailComposerView
        
        init(parent: EmailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, 
                                  didFinishWith result: MFMailComposeResult, 
                                  error: Error?) {
            // Log email result
            print("📧 Email Composer Dismissed")
            print("   Recipients: \(parent.recipients.joined(separator: ", "))")
            
            switch result {
            case .sent:
                print("   ✅ Status: Email sent successfully")
            case .saved:
                print("   💾 Status: Email saved as draft")
            case .cancelled:
                print("   ⚠️ Status: User cancelled")
            case .failed:
                print("   ❌ Status: Email failed to send")
                if let error = error {
                    print("   Error: \(error.localizedDescription)")
                }
            @unknown default:
                print("   ⚠️ Status: Unknown result")
            }
            
            controller.dismiss(animated: true)
            parent.onDismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        print("📧 Opening Email Composer")
        print("   Recipients: \(recipients.joined(separator: ", "))")
        print("   Subject: \(subject)")
        print("   Body preview: \(body.prefix(50))...")
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}

// Fallback view when email is not available
struct EmailUnavailableView: View {
    @Binding var isPresented: Bool
    let recipients: [String]
    let subject: String
    let messageBody: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Email Not Available")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Please set up an email account in Settings to submit your pre-screen.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Property Contact:")
                            .font(.headline)
                        Text(recipients.first ?? "")
                            .font(.body)
                            .textSelection(.enabled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
