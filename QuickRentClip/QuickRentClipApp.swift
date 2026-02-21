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
    
    var body: some Scene {
        WindowGroup {
            QuestionnaireView()
                .onOpenURL { url in
                    // Handle App Clip invocation URL
                    // Format: https://quickrent.app/property?id=apt101
                    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                       let queryItems = components.queryItems,
                       let id = queryItems.first(where: { $0.name == "id" })?.value {
                        propertyId = id
                        // TODO: Load questions for this property dynamically
                        print("📍 App Clip launched for property: \(id)")
                    }
                }
        }
    }
}

