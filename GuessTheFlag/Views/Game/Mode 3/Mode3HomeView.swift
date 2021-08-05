//
//  Mode3HomeView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct Mode3HomeView: View {
    var content: some View {
        Text("This is mode 3")
    }
    
    var title: String = "Mode 3"
    
    var body: some View {
        GameModeTemplateView(title: title, view: AnyView(content))
    }
}

struct Mode3HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Mode3HomeView()
    }
}
