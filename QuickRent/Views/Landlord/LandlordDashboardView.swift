//
//  LandlordDashboardView.swift
//  QuickRent (Full App - Landlord Only)
//
//  Main dashboard for landlords to manage applications
//

import SwiftUI

struct LandlordDashboardView: View {
    @EnvironmentObject var viewModel: LandlordDashboardViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Overview
                    StatsCardsView(
                        totalApplications: viewModel.applications.count,
                        pendingCount: viewModel.pendingApplications.count,
                        approvedCount: viewModel.approvedApplications.count
                    )
                    
                    // Recent Applications
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Applications")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Button("View All") {
                                viewModel.showAllApplications = true
                            }
                            .font(.subheadline)
                        }
                        .padding(.horizontal)
                        
                        if viewModel.applications.isEmpty {
                            ContentUnavailableView(
                                "No Applications Yet",
                                systemImage: "doc.text.magnifyingglass",
                                description: Text("Applications will appear here when tenants submit pre-screen forms via App Clip")
                            )
                            .frame(height: 300)
                        } else {
                            ForEach(viewModel.applications) { application in
                                NavigationLink {
                                    ApplicationDetailView(application: application)
                                } label: {
                                    ApplicationRowView(application: application)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("QuickRent")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { viewModel.showingProperties = true }) {
                            Label("Manage Properties", systemImage: "building.2")
                        }
                        Button(action: { viewModel.showingSettings = true }) {
                            Label("Settings", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingProperties) {
                PropertiesView()
            }
            .sheet(isPresented: $viewModel.showingSettings) {
                SettingsView()
            }
            .alert("Application Imported", isPresented: $viewModel.showingImportSuccess) {
                Button("View") {
                    // Scroll to the imported application
                    if let importedId = viewModel.importedApplicationId {
                        // TODO: Scroll to or highlight the application
                        print("Viewing application: \(importedId)")
                    }
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text("New tenant application has been successfully imported from Universal Link")
            }
        }
    }
}

struct StatsCardsView: View {
    let totalApplications: Int
    let pendingCount: Int
    let approvedCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(title: "Total", value: "\(totalApplications)", color: .blue)
            StatCard(title: "Pending", value: "\(pendingCount)", color: .orange)
            StatCard(title: "Approved", value: "\(approvedCount)", color: .green)
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ApplicationRowView: View {
    let application: TenantApplication
    
    var body: some View {
        HStack(spacing: 16) {
            // Status indicator
            Circle()
                .fill(application.status.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(application.propertyId)
                    .font(.headline)
                
                Text(application.contactInfo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Label("$\(application.monthlyIncome)", systemImage: "dollarsign.circle.fill")
                    Label("\(application.occupants) people", systemImage: "person.2.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(application.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(application.status.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(application.status.color)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    LandlordDashboardView()
        .environmentObject(LandlordDashboardViewModel())
}
