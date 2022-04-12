//
//  Mode1Question.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 05/08/2021.
//

import SwiftUI
import AVFoundation

enum GameType: Int, Identifiable, Codable, CaseIterable {
    case short, medium, long, allCountries
    
    var id: Int {
        switch self {
        case .short: return 15
        case .medium: return 30
        case .long: return 50
        case .allCountries: return ModelData().countries.count
        }
    }
    
    var string: String {
        switch self {
        case .short: return "Short Game"
        case .medium: return "Medium Game"
        case .long: return "Long Game"
        case .allCountries: return "All Countries"
        }
    }
}

struct Mode1Question: View {
    //MARK: - Environment Objects
    @EnvironmentObject var modelData: ModelData
    
    //MARK: - Game state properties
    @State private var btnState: [BtnState] = [.initial, .initial, .initial, .initial]
    @State private var countries: [Country] = ModelData().countries
    @State private var answer: Country = ModelData().countries[0]
    @State private var previousCountries: [Country] = []
    @State private var gameStarted: Bool = false
    
    //MARK: - Sheet state property
    @State private var sheetIsPresented: Bool = false
    
    //MARK: - AppStorage properties
    @AppStorage(SettingKeys.shouldMakeSound.rawValue) var shouldMakeSound: Bool = true
    @AppStorage(SettingKeys.gameType.rawValue) var gameType: GameType = .allCountries
    
    //MARK: - Binding Variables
    @Binding var score: Int
    @Binding var questionCount: Int
    @Binding var shouldExit: Bool
    
    //MARK: - Typealiases
    typealias AnswerBtn = Mode1AnswerBtn
    typealias FlagView = Mode1Flag
    
    var btnOpacity: Double {
        return (btnState.contains(.correct) || btnState.contains(.wrong)) ? 0.5 : 1
    }
    
    let timeOut: Double = 1.5
    
    //MARK: - View Body
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score)")
                Text("Question: \(questionCount + 1) of \(gameType.id)")
            }
            
            Text("Which Country's Flag is this?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            FlagView(flag: answer.flag)
            
            VStack(spacing: 10) {
                ForEach(0..<4) { id in
                    AnswerBtn(countries[id].name) {
                        self.validateAnswer(for: id)
                    }
                    .state(btnState[id])
                    .disabled(btnState.contains(.correct) || btnState.contains(.wrong))
                    .opacity(btnState[id] == .correct || btnState[id] == .wrong ? 1 : self.btnOpacity)
                }
            }
            .sheet(isPresented: $sheetIsPresented, onDismiss: self.reset, content: {
                Mode1EndSheet(sheetIsPresented: $sheetIsPresented, shouldExit: $shouldExit, score: score, totalQuestions: gameType.id)
            })
        }
        .padding()
        .onChange(of: self.gameType, perform: { _ in
            self.reset()
        })
    }
    
    //MARK: - Functions
    func validateAnswer(for btnID: Int) {
        if questionCount > 0 {
            self.gameStarted = true
        }
        
        if countries[btnID] == answer {
            self.score += 1
            if shouldMakeSound { AudioServicesPlaySystemSound(1057) }
            
            withAnimation {
                btnState[btnID] = .correct
            }
            
            if self.questionCount < (gameType.id - 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
                    self.reload()
                    self.questionCount += 1
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.sheetIsPresented = true
                }
            }
        } else {
            if shouldMakeSound { AudioServicesPlaySystemSound(1100) }
            
            withAnimation {
                btnState[btnID] = .wrong
                
                var i = 0
                
                for country in countries {
                    if country == answer {
                        btnState[i] = .correct
                    }
                    
                    i += 1
                }
            }
            
            if self.questionCount < (gameType.id - 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
                    self.reload()
                    self.questionCount += 1
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.sheetIsPresented = true
                }
            }
        }
    }
    
    func resetState() {
        self.countries.removeAll()
        self.btnState = [.initial, .initial, .initial, .initial]
    }
    
    func reload() {
        self.resetState()
        
        let chosenCountry = getRandomCountry(from: modelData.countries, excluding: previousCountries)
        
        self.answer = chosenCountry
        self.countries.append(chosenCountry)
        self.previousCountries.append(chosenCountry)
        
        self.populateCountries()
        
        self.countries = self.countries.shuffled()
    }
    
    func populateCountries() {
        for _ in 0..<3 {
            let newCountry = getRandomCountry(from: modelData.countries, excluding: countries)
            
            self.countries.append(newCountry)
        }
    }
    
    func reset() {
        self.score = 0
        self.questionCount = 0
        self.previousCountries.removeAll()
        self.reload()
        self.sheetIsPresented = false
        self.gameStarted = false
    }
}

struct Mode1Question_Previews: PreviewProvider {
    static var previews: some View {
        Mode1Question(score: .constant(0), questionCount: .constant(0), shouldExit: .constant(false))
            .environmentObject(ModelData())
    }
}
