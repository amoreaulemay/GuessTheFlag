//
//  Mode4HomeView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct Mode4HomeView: View {
    var content: some View {
        Text("This is mode 4")
    }
    
    var title: String = "Mode 4"
    
    var body: some View {
        GameModeTemplateView(title: title, view: AnyView(content))
    }
}

struct Mode4HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Mode4HomeView()
    }
}
