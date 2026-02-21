//
//  LandlordDashboardViewModel.swift
//  QuickRent (Full App - Landlord Only)
//
//  ViewModel for landlord dashboard
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LandlordDashboardViewModel: ObservableObject {
    @Published var applications: [TenantApplication] = []
    @Published var showingProperties = false
    @Published var showingSettings = false
    @Published var showAllApplications = false
    @Published var showingImportSuccess = false
    @Published var importedApplicationId: UUID?
    
    init() {
        loadApplications()
    }
    
    var pendingApplications: [TenantApplication] {
        applications.filter { $0.status == .pending }
    }
    
    var approvedApplications: [TenantApplication] {
        applications.filter { $0.status == .approved }
    }
    
    func loadApplications() {
        // TODO: Load from storage/backend
        // For now, load sample data
        applications = TenantApplication.sampleData
    }
    
    func updateApplicationStatus(_ application: TenantApplication, status: ApplicationStatus) {
        if let index = applications.firstIndex(where: { $0.id == application.id }) {
            applications[index].status = status
            // TODO: Save to storage
        }
    }
    
    // MARK: - Universal Link Import
    
    /// Import application from Universal Link
    func importApplication(_ applicationData: ApplicationData) {
        print("📥 Importing application from Universal Link...")
        
        // Convert ApplicationData to TenantApplication
        let tenantApp = TenantApplication(
            id: applicationData.id,
            propertyId: applicationData.propertyId,
            contactInfo: applicationData.responses["contact"] ?? "Unknown",
            monthlyIncome: Int(applicationData.responses["income"] ?? "0") ?? 0,
            occupants: Int(applicationData.responses["occupants"] ?? "0") ?? 0,
            hasPets: applicationData.responses["pets"]?.lowercased().contains("yes") ?? false,
            smokes: applicationData.responses["smoking"]?.lowercased().contains("yes") ?? false,
            desiredMoveIn: parseDate(from: applicationData.responses["movein"]) ?? Date(),
            timestamp: applicationData.timestamp,
            status: .pending,
            responses: applicationData.responses,
            applicantName: applicationData.applicantName
        )
        
        // Check for duplicates (same property + similar timestamp)
        let isDuplicate = applications.contains { existingApp in
            existingApp.propertyId == tenantApp.propertyId &&
            abs(existingApp.timestamp.timeIntervalSince(tenantApp.timestamp)) < 60 // Within 1 minute
        }
        
        if isDuplicate {
            print("⚠️ Duplicate application detected, skipping import")
            return
        }
        
        // Add to applications list (insert at beginning for newest first)
        applications.insert(tenantApp, at: 0)
        
        // Show success notification
        importedApplicationId = tenantApp.id
        showingImportSuccess = true
        
        print("✅ Successfully imported application for \(tenantApp.propertyId)")
        
        // TODO: Save to persistent storage
    }
    
    /// Parse date string from various formats
    private func parseDate(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let formatter = DateFormatter()
        let formats = [
            "MMMM d, yyyy",     // March 1, 2026
            "MM/dd/yyyy",       // 03/01/2026
            "yyyy-MM-dd"        // 2026-03-01
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
}

// MARK: - Models

struct TenantApplication: Identifiable {
    let id: UUID
    let propertyId: String
    let contactInfo: String
    let monthlyIncome: Int
    let occupants: Int
    let hasPets: Bool
    let smokes: Bool
    let desiredMoveIn: Date
    let timestamp: Date
    var status: ApplicationStatus
    let responses: [String: String]
    let applicantName: String?
    
    static let sampleData = [
        TenantApplication(
            id: UUID(),
            propertyId: "apt101",
            contactInfo: "john@example.com",
            monthlyIncome: 6000,
            occupants: 2,
            hasPets: false,
            smokes: false,
            desiredMoveIn: Date().addingTimeInterval(86400 * 14),
            timestamp: Date().addingTimeInterval(-3600),
            status: .pending,
            responses: [:],
            applicantName: "John Doe"
        ),
        TenantApplication(
            id: UUID(),
            propertyId: "apt202",
            contactInfo: "555-123-4567",
            monthlyIncome: 7500,
            occupants: 3,
            hasPets: true,
            smokes: false,
            desiredMoveIn: Date().addingTimeInterval(86400 * 30),
            timestamp: Date().addingTimeInterval(-7200),
            status: .pending,
            responses: [:],
            applicantName: "Jane Smith"
        )
    ]
}

enum ApplicationStatus: String, Codable {
    case pending = "Pending"
    case reviewing = "Reviewing"
    case approved = "Approved"
    case rejected = "Rejected"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .reviewing: return .blue
        case .approved: return .green
        case .rejected: return .red
        }
    }
}
