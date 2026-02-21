//
//  QuickRentApp.swift
//  QuickRent
//
//  Created by Kuo, Ray on 2/20/26.
//

import SwiftUI

@main
struct QuickRentApp: App {
    @StateObject private var dashboardViewModel = LandlordDashboardViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dashboardViewModel)
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
        }
    }
    
    // MARK: - Universal Link Handling
    
    private func handleUniversalLink(_ url: URL) {
        print("📱 Received URL: \(url.absoluteString)")
        
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
}
