//
//  GuessTheFlagApp.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 27/07/2021.
//

import SwiftUI

@main
struct GuessTheFlagApp: App {
    @StateObject var modelData = ModelData()
    @StateObject var educationTab = EducationTab()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(educationTab)
        }
    }
}
