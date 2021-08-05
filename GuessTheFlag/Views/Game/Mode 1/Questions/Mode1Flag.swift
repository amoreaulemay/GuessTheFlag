//
//  Mode1Flag.swift
//  GuessTheFlag
//
//  Created by Alexandre Moreau-Lemay on 04/08/2021.
//

import SwiftUI

struct Mode1Flag: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .padding(30)
            .shadow(radius: 10)
    }
}

struct Mode1Flag_Previews: PreviewProvider {
    static var previews: some View {
        Mode1Flag(flag: "ca")
    }
}
