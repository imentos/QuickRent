//
//  ContentView.swift
//  QuickRent (Full App - Landlord Only)
//
//  Created by Kuo, Ray on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dashboardViewModel: LandlordDashboardViewModel
    
    var body: some View {
        LandlordDashboardView()
    }
}

#Preview {
    ContentView()
        .environmentObject(LandlordDashboardViewModel())
}
