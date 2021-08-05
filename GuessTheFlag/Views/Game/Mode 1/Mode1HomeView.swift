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
    @EnvironmentObject var modelData: ModelData
    
    @State private var btnState: [BtnState] = [.initial, .initial, .initial, .initial]
    @State private var countries: [String] = ["Canada", "Zimbabwe", "Greece", "France"]
    @State private var answer: String = "Canada"
    @State private var flag: String = "ca"
    
    typealias AnswerBtn = Mode1AnswerBtn
    typealias FlagView = Mode1Flag
    
    var content: some View {
        VStack {
            Text("Which Country's Flag is this?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            FlagView(flag: flag)
            
            VStack(spacing: 10) {
                ForEach(0..<countries.count) { id in
                    AnswerBtn(countries[id]) {
                        self.validateAnswer(for: id)
                    }.state(btnState[id])
                }
            }
        }
        .padding()
    }
    
    var title: String = Modes.0
    
    var body: some View {
        GameModeTemplateView(title: title, view: AnyView(content))
            .onAppear(perform: {
                self.setAnswer()
                
                educationTab.isDisabled = true
            })
    }
    
    func validateAnswer(for btnID: Int) {
        if countries[btnID] == answer {
            print("Good one")
            btnState[btnID] = .correct
        } else {
            print("Wrong answer")
            btnState[btnID] = .wrong
        }
    }
    
    func resetState() {
        self.answer = ""
        self.countries.removeAll()
        self.btnState = [.initial, .initial, .initial, .initial]
    }
    
    func setAnswer() {
        self.resetState()
        
        let chosenCountry = getRandomCountry(from: modelData.countries)
        
        self.answer = chosenCountry.name
        self.flag = chosenCountry.flag
        self.countries.append(chosenCountry.name)
        
        self.populateCountries()
        
        self.countries = self.countries.shuffled()
    }
    
    func populateCountries() {
        for _ in 0..<3 {
            let newCountry = getRandomCountry(from: modelData.countries, excluding: countries)
            
            self.countries.append(newCountry.name)
        }
    }
}

struct Mode1HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Mode1HomeView()
            .environmentObject(EducationTab())
            .environmentObject(ModelData())
    }
}
