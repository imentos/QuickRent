//
//  SMSComposerView.swift
//  QuickRent
//
//  SMS composer wrapper for submission with Universal Link
//

import SwiftUI
import MessageUI

struct SMSComposerView: UIViewControllerRepresentable {
    let recipients: [String]
    let body: String
    var onDismiss: () -> Void
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: SMSComposerView
        
        init(parent: SMSComposerView) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, 
                                        didFinishWith result: MessageComposeResult) {
            // Log SMS result
            print("📱 SMS Composer Dismissed")
            print("   Recipients: \(parent.recipients.joined(separator: ", "))")
            
            switch result {
            case .sent:
                print("   ✅ Status: Message sent successfully")
            case .cancelled:
                print("   ⚠️ Status: User cancelled")
            case .failed:
                print("   ❌ Status: Message failed to send")
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
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        print("📱 Opening SMS Composer")
        print("   Recipients: \(recipients.joined(separator: ", "))")
        print("   Body preview: \(body.prefix(50))...")
        
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = recipients
        composer.body = body
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}

// Fallback view when SMS is not available
struct SMSUnavailableView: View {
    @Binding var isPresented: Bool
    let recipients: [String]
    let messageBody: String
    let universalLink: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "message.badge.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("SMS Not Available")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("SMS is not available on this device, but you can copy the link below and share it manually.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let link = universalLink {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Application Link:")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = link
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            Text(link)
                                .font(.caption)
                                .foregroundColor(.blue)
                                .lineLimit(3)
                                .textSelection(.enabled)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Landlord Contact:")
                            .font(.headline)
                        Text(recipients.first ?? "Not specified")
                            .font(.body)
                            .textSelection(.enabled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                Text("Copy the link and share it via any messaging app with the landlord.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
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

// Preview
#Preview("SMS Composer") {
    Text("SMS Preview")
        .sheet(isPresented: .constant(true)) {
            if MFMessageComposeViewController.canSendText() {
                SMSComposerView(
                    recipients: ["+1234567890"],
                    body: "Hi! I'm interested in apt101. Here's my application: https://quickrent.app/application?data=test123",
                    onDismiss: {}
                )
            } else {
                SMSUnavailableView(
                    isPresented: .constant(true),
                    recipients: ["+1234567890"],
                    messageBody: "Test message",
                    universalLink: "https://quickrent.app/application?data=test123"
                )
            }
        }
}
