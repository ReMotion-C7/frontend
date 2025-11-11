//
//  EditDetailPatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 04/11/25.
//

import SwiftUI

struct EditPatientDetailPage: View {
    @ObservedObject var viewModel: PatientViewModel
    let patient: Patient
    let fisioId: Int
    
    @State private var selectedPhase: Int
    @State private var symptoms: [String]
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""
    
    
    init(viewModel: PatientViewModel, patient: Patient, fisioId: Int) {
        self.viewModel = viewModel
        self.patient = patient
        self.fisioId = fisioId
        
        _selectedPhase = State(initialValue: patient.phase)
        _symptoms = State(initialValue: patient.symptoms)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    patientHeaderSection(patient: patient)
                    therapyInfoSection(patient: patient)
                    phaseEditorSection
                    symptomsEditorSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            
            saveButtonSection
        }
        .background(Color.white)
        .navigationTitle("Ubah Detail Pasien")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.gray)
                }
            }
        }
        .alert("Update Gagal", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage.isEmpty ? "Gagal menyimpan data." : alertMessage)
        }
    }
    
    
    private var phaseEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pilih Fase Pasien")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
            
            Menu {
                Button(action: { selectedPhase = 1 }) {
                    Text("Fase 1")
                }
                Button(action: { selectedPhase = 2 }) {
                    Text("Fase 2")
                }
                Button(action: { selectedPhase = 3 }) {
                    Text("Fase 3")
                }
            } label: {
                HStack {
                    Text("Fase \(selectedPhase)")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(alignment: .leading)
                .frame(width: 200)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var symptomsEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Gejala Pasien")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
            
            ForEach(symptoms.indices, id: \.self) { index in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                    
                    TextField("Deskripsi gejala...", text: $symptoms[index])
                        .font(.system(size: 14))
                        .padding(.vertical, 14)
                    
                    Spacer()
                    
                    Button(action: {
                        symptoms.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 16)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
            
            Button(action: {
                symptoms.append("")
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                    Text("Tambahkan gejala")
                        .font(.system(size: 14))
                }
                .foregroundColor(.gray)
            }
            .padding(.top, 4)
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button(action: {
                Task {
                    let validSymptoms = symptoms.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    
                    let success = await viewModel.editPatientDetail(
                        fisioId: fisioId,
                        patientId: patient.id,
                        phase: selectedPhase,
                        symptoms: validSymptoms
                    )

                    if success {
                        dismiss()
                    } else {
                        alertMessage = viewModel.errorMessage
                        showingErrorAlert = true
                    }
                }
            }) {
                Text("Simpan Perubahan")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.white)
    }
    
    
    private func patientHeaderSection(patient: Patient) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.black)
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(patient.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(patient.gender)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                        )
                }
                
                Text(patient.phoneNumber + " | " + formatDate(patient.dateOfBirth))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func therapyInfoSection(patient: Patient) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text("Mulai terapi : \(formatDate(patient.therapyStartDate))")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "id_ID")
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
