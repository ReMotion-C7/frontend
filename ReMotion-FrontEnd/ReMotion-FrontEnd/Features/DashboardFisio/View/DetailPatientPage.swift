//
//  DetailPatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct DetailPatientPage: View {
    //    let patient: Patient?
    @ObservedObject var viewModel: DashboardFisioViewModel
    let fisioId: Int
    let patientId: Int
    
    var body: some View {
        
        if viewModel.isLoading {
            LoadingView(message: "Memuat data detail pasien...")
        }
        else if viewModel.errorMessage != "" {
            ErrorView(message: viewModel.errorMessage)
        }
        else if let patient = viewModel.patient {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 32))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text(patient.name)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(patient.gender)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.6))
                                    .cornerRadius(12)
                            }
                            
                            Text("\(patient.phoneNumber) | \(DateHelper.formatDateForDisplay(dateString: patient.dateOfBirth))")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text("Tanggal mulai terapi : \(DateHelper.formatDateForDisplay(dateString: patient.therapyStartDate))")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("Fase \(patient.phase)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(patient.getPhaseColor())
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gejala")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            SymptomRow(text: "Bunyi letupan")
                            SymptomRow(text: "Nyeri yang tajam dan tiba-tiba di lutut")
                            SymptomRow(text: "Pembengkakan")
                            SymptomRow(text: "Lutut terasa tidak stabil, goyah, atau seperti mau lepas saat digunakan untuk menumpu beban")
                            SymptomRow(text: "Sulit untuk menggerakan atau memergangkan lutut, termasuk menekuk atau meluruskan")
                            SymptomRow(text: "Terjadi memar di sekitar lutut")
                            SymptomRow(text: "Pasien mungkin sulit atau pincang saat berjalan")
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Daftar Gerakan Latihan")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Tambah Gerakan")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .cornerRadius(8)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(patient.exercises) { exercise in
                                    PatientMovementCard(
                                        movement: Movement(
                                            id: exercise.id,
                                            name: exercise.name,
                                            type: exercise.type,
                                            description: exercise.description,
                                            muscle: exercise.muscle,
                                            image: exercise.image
                                        ),
                                        sets: "\(exercise.set)x Set",
                                        duration: exercise.type.lowercased() == "waktu"
                                        ? "\(exercise.repOrTime) detik"
                                        : "\(exercise.repOrTime)x Rep"
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 32)
            }
//            .onAppear {
//                Task {
//                    try await viewModel.readPatientDetail(fisioId: fisioId, patientId: patientId)
//                }
//            }
            .background(Color.white)
        }
        
    }
}

//#Preview {
//    DetailPatientPage(patient: samplePatients[0])
//}
