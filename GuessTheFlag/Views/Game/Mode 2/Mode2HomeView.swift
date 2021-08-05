//
//  Mode2HomeView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct Mode2HomeView: View {
    var content: some View {
        Text("This is mode 2")
    }
    
    var title: String = "Mode 2"
    
    var body: some View {
        GameModeTemplateView(title: title, view: AnyView(content))
    }
}

struct Mode2HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Mode2HomeView()
    }
}
