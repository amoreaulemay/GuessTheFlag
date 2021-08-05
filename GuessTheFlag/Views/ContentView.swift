//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 27/07/2021.
//

import SwiftUI
import Combine

class EducationTab: ObservableObject {
    @Published var isDisabled = false
}

struct ContentView: View {
    @State private var selectedTab: Tab = .game
    @EnvironmentObject var educationTab: EducationTab
    
    
    enum Tab {
        case game
        case education
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GameHomeView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
                .tag(Tab.game)
            
            if !educationTab.isDisabled {
                CountriesListView()
                    .tabItem {
                        Label("Education", systemImage: "text.book.closed")
                    }
                    .tag(Tab.education)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
