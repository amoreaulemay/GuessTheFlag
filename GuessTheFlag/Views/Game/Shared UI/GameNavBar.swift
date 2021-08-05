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
    
    var trailingPadding: CGFloat = 30
    var title: String = "Title"
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                
                Button(action: {
                    educationTab.isDisabled = false
                    self.presentationMode.wrappedValue.dismiss()
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
    }
}
