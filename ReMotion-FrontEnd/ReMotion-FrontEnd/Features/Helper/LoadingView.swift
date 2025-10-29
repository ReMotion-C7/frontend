//
//  LoadingView.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import SwiftUI

struct LoadingView: View {
    
    let message: String
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(2.0) // ukuran lebih besar
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .padding()
            Text(message)
                .foregroundColor(.gray)
                .font(.system(size: 16))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.5))
    }
}
