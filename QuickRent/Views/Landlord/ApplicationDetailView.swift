//
//  ApplicationDetailView.swift
//  QuickRent (Full App - Landlord Only)
//
//  Detailed view of a tenant application
//

import SwiftUI

struct ApplicationDetailView: View {
    let application: TenantApplication
    @Environment(\.dismiss) private var dismiss
    @State private var showingApproveConfirmation = false
    @State private var showingRejectConfirmation = false
    @State private var notes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Property: \(application.propertyId.uppercased())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Application Details")
                        .font(.system(size: 28, weight: .bold))
                    
                    HStack {
                        Label(application.status.rawValue, systemImage: "circle.fill")
                            .foregroundColor(application.status.color)
                        
                        Spacer()
                        
                        Text(application.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Applicant Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Applicant Information")
                        .font(.headline)
                    
                    InfoRow(label: "Contact", value: application.contactInfo, icon: "envelope.fill")
                    InfoRow(label: "Monthly Income", value: "$\(application.monthlyIncome)", icon: "dollarsign.circle.fill")
                    InfoRow(label: "Occupants", value: "\(application.occupants) people", icon: "person.2.fill")
                    InfoRow(label: "Pets", value: application.hasPets ? "Yes" : "No", icon: "pawprint.fill")
                    InfoRow(label: "Smoking", value: application.smokes ? "Yes" : "No", icon: "smoke.fill")
                    InfoRow(label: "Move-In Date", value: application.desiredMoveIn.formatted(date: .abbreviated, time: .omitted), icon: "calendar")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Notes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Landlord Notes")
                        .font(.headline)
                    
                    TextEditor(text: $notes)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
                
                // Action Buttons
                if application.status == .pending {
                    HStack(spacing: 12) {
                        Button(action: {
                            showingApproveConfirmation = true
                        }) {
                            Label("Approve", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingRejectConfirmation = true
                        }) {
                            Label("Reject", systemImage: "xmark.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Approve Application", isPresented: $showingApproveConfirmation) {
            Button("Approve") {
                // TODO: Update status
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to approve this application?")
        }
        .confirmationDialog("Reject Application", isPresented: $showingRejectConfirmation) {
            Button("Reject", role: .destructive) {
                // TODO: Update status
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to reject this application?")
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}

struct PropertiesView: View {
    var body: some View {
        NavigationStack {
            Text("Properties Management")
                .navigationTitle("Properties")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Text("Settings")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    NavigationStack {
        ApplicationDetailView(application: TenantApplication.sampleData[0])
    }
}
