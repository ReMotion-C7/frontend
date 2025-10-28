//
//  SymptomRow.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 26/10/25.
//

import SwiftUI

struct SymptomRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 14))
                .foregroundColor(.black)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

