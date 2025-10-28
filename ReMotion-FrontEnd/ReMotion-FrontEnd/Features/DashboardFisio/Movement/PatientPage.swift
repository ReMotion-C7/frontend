//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

<<<<<<<< HEAD:ReMotion-FrontEnd/ReMotion-FrontEnd/Features/DashboardFisio/Patient/PatientListPage.swift
struct PatientListPage: View {
    let patients = dummyPatient
========
struct PatientPage: View {
    let patients = samplePatients
>>>>>>>> dev:ReMotion-FrontEnd/ReMotion-FrontEnd/Features/DashboardFisio/Movement/PatientPage.swift

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
        }
    }
}

#Preview {
    PatientListPage()
}
