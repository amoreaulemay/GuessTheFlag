//
//  SettingsView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 12/08/2021.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingKeys.shouldMakeSound.rawValue) var shouldMakeSound = true
    @AppStorage(SettingKeys.gameType.rawValue) var gameType: GameType = .short
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sound Options")) {
                    Toggle(isOn: $shouldMakeSound) {
                        Text("Activate Sound")
                    }
                }
                
                Section(header: Text("Game Options")) {
                    Picker("Game Type", selection: $gameType) {
                        ForEach(GameType.allCases) { gType in
                            Text(gType.string)
                                .tag(gType)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
