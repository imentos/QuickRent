//
//  ContentView.swift
//  QuickRent (Full App - Landlord Only)
//
//  Created by Kuo, Ray on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dashboardViewModel: LandlordDashboardViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        LandlordDashboardView()
            .sheet(isPresented: $appState.showingQuestionnaire) {
                NavigationStack {
                    QuestionnaireView(
                        landlordPhone: appState.questionnaireLandlordPhone,
                        propertyId: appState.questionnairePropertyId
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                appState.closeQuestionnaire()
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(LandlordDashboardViewModel())
}
