//
//  PatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientPage: View {
    
    @ObservedObject var viewModel: DashboardFisioViewModel
    let fisioId: Int
    
    var body: some View {
        NavigationStack {
            
            if viewModel.isLoading {
                
                LoadingView(message: "Memuat data pasien...")
                
            }
            else {
                ScrollView {
                    if viewModel.errorMessage != "" {
                        VStack {
                            Spacer()
                            Text(viewModel.errorMessage)
                                .font(.system(size: 24, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.patients) { patient in
                                //                            NavigationLink(destination: DetailPatientPage(patient: patient)) {
                                PatientCard(patient: patient)
                                //                            }
                                    .buttonStyle(PlainButtonStyle())
                            }
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
}

//#Preview {
//    PatientPage()
//}
