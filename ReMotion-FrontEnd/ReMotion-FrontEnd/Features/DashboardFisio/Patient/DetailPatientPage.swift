//
//  DetailPatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct DetailPatientPage: View {
    let patient: Patient
    @State private var showExerciseSheet = false
    @State private var patientMovements: [Movement] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                patientHeaderSection
                therapyInfoSection
                symptomsSection
                exerciseListSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showExerciseSheet) {
            MovementToPatientModal(selectedMovements: $patientMovements)
        }
    }
    
    // MARK: - Patient Header Section
    private var patientHeaderSection: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(
                    Color.black
                )
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 34))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text(patient.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(patient.gender.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.7))
                        )
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    
                    Text(patient.phoneNumber)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    
                    Text(patient.birthDate)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Therapy Info Section
    private var therapyInfoSection: some View {
        HStack(spacing: 12) {
            // Tanggal Mulai Terapi
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text("Tanggal mulai terapi : \(patient.therapyDate)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Fase Badge
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Text("Fase \(patient.phase)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(patient.getPhaseColor())
            )
            .shadow(color: patient.getPhaseColor().opacity(0.3), radius: 6, x: 0, y: 3)
        }
    }
    
    // MARK: - Symptoms Section
    private var symptomsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
                Text("Gejala")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            
            
            VStack(alignment: .leading, spacing: 10) {
                SymptomRow(text: "Bunyi letupan")
                SymptomRow(text: "Nyeri yang tajam dan tiba-tiba di lutut")
                SymptomRow(text: "Pembengkakan")
                SymptomRow(text: "Lutut terasa tidak stabil, goyah, atau seperti mau lepas saat digunakan untuk menumpu beban")
                SymptomRow(text: "Sulit untuk menggerakan atau memergangkan lutut, termasuk menekuk atau meluruskan")
                SymptomRow(text: "Terjadi memar di sekitar lutut")
                SymptomRow(text: "Pasien mungkin sulit atau pincang saat berjalan")
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
    }
    
    // MARK: - Exercise List Section
    private var exerciseListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                    
                    Text("Daftar Gerakan Latihan")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                
                Spacer()
                
                Button(action: {
                    showExerciseSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("Tambah Gerakan")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                }
            }
            
            if patientMovements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "figure.walk.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.4))
                    
                    Text("Belum ada gerakan latihan ditambahkan")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Klik tombol 'Tambah Gerakan' untuk menambahkan")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(patientMovements) { movement in
                            PatientMovementCard(
                                movement: movement,
                                sets: "15x Set",
                                duration: movement.label == "Waktu" ? "10 detik" : "30x Rep"
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    DetailPatientPage(
        patient: Patient(
            name: "Daniel Fernando",
            gender: .laki,
            phase: 1,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
    )
}
