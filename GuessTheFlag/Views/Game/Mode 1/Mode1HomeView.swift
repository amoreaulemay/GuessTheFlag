//
//  Mode1HomeView.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

enum BtnState {
    case initial, correct, wrong
    
    var color: Color {
        switch self {
        case .initial: return .blue
        case .correct: return .green
        case .wrong: return .red
        }
    }
}

struct Mode1HomeView: View {
    @EnvironmentObject var educationTab: EducationTab
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var score: Int = 0
    @State private var questionCount: Int = 0
    @State private var shouldExit: Bool = false
    
    var content: some View {
        Mode1Question(score: $score, questionCount: $questionCount, shouldExit: $shouldExit)
            .onChange(of: shouldExit, perform: { value in
                if value {
                    exit()
                }
            })
    }
    
    var title: String = Modes.0
    
    var body: some View {
        GameModeTemplateView(title: title, view: AnyView(content))
            .onAppear(perform: {
                educationTab.isDisabled = true
            })
    }
    
    func exit() {
        educationTab.isDisabled = false
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct Mode1HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Mode1HomeView()
            .environmentObject(EducationTab())
            .environmentObject(ModelData())
    }
}
