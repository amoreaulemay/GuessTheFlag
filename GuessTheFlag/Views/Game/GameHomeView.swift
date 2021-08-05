//
//  GameHomeView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct GameHomeView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                NavigationLink(destination: Mode1HomeView()) {
                    Text(Modes.0)
                }
                
                NavigationLink(destination: Mode2HomeView()) {
                    Text(Modes.1)
                }
                
                NavigationLink(destination: Mode3HomeView()) {
                    Text(Modes.2)
                }
                
                NavigationLink(destination: Mode4HomeView()) {
                    Text(Modes.3)
                }
            }
            
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct GameHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GameHomeView()
    }
}
