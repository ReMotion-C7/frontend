//
//  PasienPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PasienPage: View {
    var body: some View {
        PasienCard(
            name: "Daniel Fernando",
            phase: 1,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
        

        PasienCard(
            name: "Daniel Fernando",
            phase: 2,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
        
        PasienCard(
            name: "Daniel Fernando",
            phase: 3,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
        }

    }

#Preview {
    PasienPage()
}
