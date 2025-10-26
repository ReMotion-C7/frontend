//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientPage: View {
    let patients = dummyPatient

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(patients) { patient in
                        NavigationLink(destination: DetailPatientPage(patient: patient)) {
                            PatientCard(patient: patient)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    PatientPage()
}
