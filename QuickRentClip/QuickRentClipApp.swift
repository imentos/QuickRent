//
//  QuickRentClipApp.swift
//  QuickRentClip (App Clip - Tenant Questionnaire)
//
//  Created by Kuo, Ray on 2/20/26.
//

import SwiftUI

@main
struct QuickRentClipApp: App {
    @State private var propertyId: String?
    @State private var landlordPhone: String?
    
    var body: some Scene {
        WindowGroup {
            QuestionnaireView(landlordPhone: landlordPhone, propertyId: propertyId)
                .onOpenURL { url in
                    // Handle App Clip invocation URL
                    // Format: https://quickrent.app/property?id=apt101&phone=%2B1234567890
                    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                       let queryItems = components.queryItems {
                        
                        // Extract property ID
                        if let id = queryItems.first(where: { $0.name == "id" })?.value {
                            propertyId = id
                            print("📍 App Clip launched for property: \(id)")
                        }
                        
                        // Extract landlord phone
                        if let phone = queryItems.first(where: { $0.name == "phone" })?.value {
                            landlordPhone = phone
                            print("📞 Landlord phone: \(phone)")
                        }
                    }
                }
        }
    }
}

