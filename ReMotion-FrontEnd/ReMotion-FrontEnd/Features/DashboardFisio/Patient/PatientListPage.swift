//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientListPage: View {
    
    @ObservedObject var viewModel: PatientViewModel
    let fisioId: Int
    
    var body: some View {
        NavigationStack {
            
            if viewModel.isLoading {
                LoadingView(message: "Memuat data pasien...")
            }
            else if viewModel.errorMessage != "" {
                ErrorView(message: viewModel.errorMessage)
            }
            else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.patients) { patient in
                            NavigationLink(destination: DetailPatientPage(viewModel: viewModel, fisioId: fisioId, patientId: patient.id))
                            {
                                PatientCard(patient: patient)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
                .background(Color.white)
                .padding(.vertical, 20)
            }
            
        }
        .onAppear {
            Task {
                try await viewModel.readPatients(fisioId: fisioId)
            }
        }
    }
     
}

//#Preview {
//    PatientPage()
//}
