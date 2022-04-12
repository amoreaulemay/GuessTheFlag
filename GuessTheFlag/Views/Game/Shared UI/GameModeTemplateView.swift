//
//  GameModeTemplateView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct GameModeTemplateView: View {    
    var title: String = "Test View"
    var view: AnyView = AnyView(Text("Test View"))
    
    var body: some View {
        VStack {
            GameNavBar(title: title)
            
            Spacer()
            
            view
            
            Spacer()
        }
        
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct GameModeTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeTemplateView()
    }
}
