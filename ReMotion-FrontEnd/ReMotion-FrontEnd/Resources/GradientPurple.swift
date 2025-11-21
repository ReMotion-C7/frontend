//
//  Color.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 21/11/25.
//

import SwiftUI

struct GradientPurple: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color("lightPurple"),
                Color("darkPurple")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

