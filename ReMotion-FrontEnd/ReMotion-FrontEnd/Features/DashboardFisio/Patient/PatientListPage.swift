//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientListPage: View {
    let patients = samplePatients

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
                .padding(.vertical, 20)
            }
            
            .background(Color.white)
        }
    }
}

#Preview {
    PatientListPage()
}
