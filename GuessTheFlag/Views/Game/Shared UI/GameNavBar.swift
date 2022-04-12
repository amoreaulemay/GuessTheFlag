//
//  GameNavBar.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 02/08/2021.
//

import SwiftUI

struct GameNavBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var educationTab: EducationTab
    
    @State private var showAlert = false
    
    var trailingPadding: CGFloat = 30
    var title: String = "Title"
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                
                Button(action: {
                    self.showAlert = true
                }, label: {
                    Image(systemName: "xmark")
                        .padding(.trailing, trailingPadding)
                        .padding([.top, .bottom], 10)
                })
                .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .fontWeight(.bold)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure you want to quit?"),
                  message: Text("If you quit in the middle of a game, your score will be lost."),
                  primaryButton: .destructive(Text("Quit Game"), action: self.exit),
                  secondaryButton: .cancel(Text("Resume Game")))
        }
    }
    
    func exit() {
        educationTab.isDisabled = false
        self.presentationMode.wrappedValue.dismiss()
    }
}
