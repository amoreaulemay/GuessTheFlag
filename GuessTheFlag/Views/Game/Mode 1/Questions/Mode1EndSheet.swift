//
//  Mode1EndSheet.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 05/08/2021.
//

import SwiftUI
import AVFoundation

struct Mode1EndSheet: View {
    @Binding var sheetIsPresented: Bool
    @Binding var shouldExit: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var educationTab: EducationTab
    
    @AppStorage(SettingKeys.shouldMakeSound.rawValue) var shouldMakeSound = true
    
    var score: Int
    var totalQuestions: Int
    var percentage: Int {
        let absolutePercentage = Double(score) / Double(totalQuestions) * 100
        return min(Int(absolutePercentage.rounded(.down)), 100)
    }
    
    @State private var result: Float = 0
    
    enum NotificationSound: UInt32 {
        case abysmal = 1024
        case bad = 1026
        case ok = 1027
        case good = 1020
        case perfect = 1025
        
        var soundID: UInt32 {
            return self.rawValue
        }
    }
    
    var color: Color {
        switch percentage {
        case 0..<30: return Color.red // Abysmal Score
        case 30..<60: return Color.orange // Bad Score
        case 60..<80: return Color.yellow // Ok Score
        case 80..<100: return Color.green // Good Score
        case 100: return Color.purple // Perfect Score
        default: return Color.gray
        }
    }
    
    var title: String {
        switch percentage {
        case 0..<30: return "Ouch!"
        case 30..<60: return "Well..."
        case 60..<80: return "Alright!"
        case 80..<100: return "Great!"
        case 100: return "Perfect!"
        default: return "Strange..."
        }
    }
    
    var message: String {
        switch percentage {
        case 0..<30: return "You should keep on studying!"
        case 30..<60: return "It wasn't easy! You'll do better next time!"
        case 60..<80: return "At least you passed the 60% mark!"
        case 80..<100: return "It's a good score!"
        case 100: return "You couldn't have done better!"
        default: return "You've managed to obtain an impossible score!"
        }
    }
    
    var sound: UInt32 {
        var notificationSound: NotificationSound
        
        switch percentage {
        case 0..<30: notificationSound = .abysmal
        case 30..<60: notificationSound = .bad
        case 60..<80: notificationSound = .ok
        case 80..<100: notificationSound = .good
        case 100: notificationSound = .perfect
        default: notificationSound = .perfect
        }
        
        return notificationSound.soundID
    }
    
    var body: some View {
        ZStack {
            self.color.opacity(0.1)
            
            VStack(spacing: 20) {
                Text("\(score) / \(totalQuestions)")
                    .font(.headline)
                    .fontWeight(.heavy)
                
                
                ProgressBar(progress: $result, color: self.color)
                    .frame(width: 150, height: 150)
                    .padding()
                
                Text(title)
                    .font(.largeTitle)
                
                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    self.sheetIsPresented = false
                }) {
                    Text("Restart Game")
                }
                
                Button(action: exit, label: {
                    Text("Exit Game")
                })
            }
            .padding(50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear(
            perform: {
                self.result = Float.minimum(Float(score) / Float(totalQuestions), 1)
                if shouldMakeSound { AudioServicesPlaySystemSound(self.sound) }
            }
        )
    }
    
    func exit() {
        educationTab.isDisabled = false
        self.presentationMode.wrappedValue.dismiss()
        self.shouldExit = true
    }
}

struct Mode1EndSheet_Previews: PreviewProvider {
    static var previews: some View {
        Mode1EndSheet(sheetIsPresented: .constant(true), shouldExit: .constant(false), score: 256, totalQuestions: 257)
    }
}
