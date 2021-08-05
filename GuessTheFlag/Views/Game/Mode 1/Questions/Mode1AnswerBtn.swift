//
//  Mode1AnswerBtn.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 04/08/2021.
//

import SwiftUI

struct Mode1AnswerBtn: View {    
    var action: () -> Void
    var label: String
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .shadow(radius: 3)
    }
    
    func state(_ state: BtnState) -> some View {
        self
            .background(
                Rectangle().fill(state.color)
            )
    }
}
