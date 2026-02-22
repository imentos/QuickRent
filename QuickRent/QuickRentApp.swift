//
//  QuickRentApp.swift
//  QuickRent
//
//  Created by Kuo, Ray on 2/20/26.
//

import SwiftUI
import Combine

@main
struct QuickRentApp: App {
    @StateObject private var dashboardViewModel = LandlordDashboardViewModel()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dashboardViewModel)
                .environmentObject(appState)
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
        }
    }
    
    // MARK: - Universal Link Handling
    
    private func handleUniversalLink(_ url: URL) {
        print("📱 Received URL: \(url.absoluteString)")
        print("   Scheme: \(url.scheme ?? "nil"), Host: \(url.host ?? "nil"), Path: \(url.path)")
        
        // For custom schemes (quickrent://), the identifier is in the host
        // For Universal Links (https://), the identifier is in the path
        let identifier = url.scheme == "quickrent" ? (url.host ?? "") : url.path
        
        if identifier == "/application" || identifier == "application" {
            // Handle application data import (from tenant SMS)
            handleApplicationImport(url)
        } else if identifier == "/property" || identifier == "property" {
            // Handle property questionnaire (from QR code scan with full app installed)
            handlePropertyQuestionnaire(url)
        } else {
            print("⚠️ Unknown URL identifier: \(identifier)")
        }
    }
    
    private func handleApplicationImport(_ url: URL) {
        // Parse Universal Link
        guard let applicationData = ApplicationData.parseUniversalLink(url) else {
            print("❌ Failed to parse Universal Link")
            return
        }
        
        // Import application to dashboard
        Task { @MainActor in
            dashboardViewModel.importApplication(applicationData)
        }
    }
    
    private func handlePropertyQuestionnaire(_ url: URL) {
        // Extract query parameters
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            print("❌ No query parameters found")
            return
        }
        
        let propertyId = queryItems.first(where: { $0.name == "id" })?.value
        let landlordPhone = queryItems.first(where: { $0.name == "phone" })?.value
        
        // Show questionnaire in full app
        Task { @MainActor in
            appState.showQuestionnaire(propertyId: propertyId, landlordPhone: landlordPhone)
        }
    }
}

// MARK: - App State

@MainActor
class AppState: ObservableObject {
    @Published var showingQuestionnaire = false
    @Published var questionnairePropertyId: String?
    @Published var questionnaireLandlordPhone: String?
    
    func showQuestionnaire(propertyId: String?, landlordPhone: String?) {
        self.questionnairePropertyId = propertyId
        self.questionnaireLandlordPhone = landlordPhone
        self.showingQuestionnaire = true
        print("📋 Opening questionnaire for property: \(propertyId ?? "unknown")")
    }
    
    func closeQuestionnaire() {
        self.showingQuestionnaire = false
        self.questionnairePropertyId = nil
        self.questionnaireLandlordPhone = nil
    }
}
