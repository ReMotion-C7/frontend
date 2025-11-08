//
//  EmptyView.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 08/11/25.
//

import SwiftUI

struct BlankView: View {
    
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
