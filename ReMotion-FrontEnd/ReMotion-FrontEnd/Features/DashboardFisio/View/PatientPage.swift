//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientPage: View {
    @ObservedObject var viewModel: PatientViewModel
    let fisioId: Int
    let searchText: String
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView(message: "Memuat data pasien...")
            } else if viewModel.errorMessage != "" {
                ErrorView(message: viewModel.errorMessage)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Filter
                        ForEach(filteredPatients) { patient in
                            NavigationLink(
                                destination: DetailPatientPage(
                                    viewModel: viewModel,
                                    fisioId: fisioId,
                                    patientId: patient.id
                                )
                            ) {
                                PatientCard(patient: patient)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.readPatients(fisioId: fisioId)
            }
        }
    }
    
    private var filteredPatients: [ReadPatientData] {
        if searchText.isEmpty {
            return viewModel.patients
        } else {
            return viewModel.patients.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

//#Preview {
//    PatientPage()
//}
