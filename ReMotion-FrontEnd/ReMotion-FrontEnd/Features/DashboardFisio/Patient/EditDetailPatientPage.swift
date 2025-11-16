//
//  EditPatientDetailPage.swift
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
    @State private var diagnostic: String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingErrorAlert = false
    @State private var showingSuccessAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: PatientViewModel, patient: Patient, fisioId: Int) {
        self.viewModel = viewModel
        self.patient = patient
        self.fisioId = fisioId
        
        _selectedPhase = State(initialValue: patient.phase)
        _symptoms = State(initialValue: patient.symptoms.isEmpty ? [""] : patient.symptoms)
        
        if let patientDetail = viewModel.patient, let diag = patientDetail.diagnostic {
            _diagnostic = State(initialValue: diag)
        } else {
            _diagnostic = State(initialValue: "")
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    patientHeaderSection(patient: patient)
                    
                    therapyInfoSection(patient: patient)
                    phaseEditorSection
                    symptomsEditorSection
                    diagnosticEditorSection
                    
                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            
            saveButtonSection
        }
        .padding(20)
        .background(Color.white)
        .navigationTitle("Ubah Detail Pasien")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Kembali")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .alert("Berhasil", isPresented: $showingSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Data pasien berhasil diperbarui")
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
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Menu {
                Button(action: { selectedPhase = 1 }) {
                    HStack {
                        Text("Fase 1 (Pre-Op)")
                        if selectedPhase == 1 {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { selectedPhase = 2 }) {
                    HStack {
                        Text("Fase 2 (Post-Op)")
                        if selectedPhase == 2 {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { selectedPhase = 3 }) {
                    HStack {
                        Text("Fase 3 (Post-Op)")
                        if selectedPhase == 3 {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { selectedPhase = 4 }) {
                    HStack {
                        Text("Fase 4 (Post-Op)")
                        if selectedPhase == 4 {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Fase \(selectedPhase) \(getPhaseLabel(selectedPhase))")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
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
            HStack {
                Text("Keluhan Pasien")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(symptoms.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count) keluhan")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                ForEach(symptoms.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 6, height: 6)
                        
                        ZStack(alignment: .leading) {
                            if symptoms[index].isEmpty {
                                Text("Deskripsi keluhan pasien...")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            
                            TextField("", text: $symptoms[index])
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                        
                        if symptoms.count > 1 {
                            Button(action: {
                                symptoms.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray.opacity(0.6))
                                    .font(.system(size: 20))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemGray6).opacity(0.6))
                    .cornerRadius(8)
                }
            }
            
            Button(action: {
                symptoms.append("")
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                    Text("Tambahkan keluhan")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.black)
            }
            .padding(.top, 4)
        }
    }
    
    private var diagnosticEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hasil Diagnosa")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            ZStack(alignment: .topLeading) {
                if diagnostic.isEmpty {
                    Text("Tuliskan hasil diagnosa pasien...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                }
                
                TextEditor(text: $diagnostic)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 140, maxHeight: 200)
                    .padding(8)
            }
            .background(Color(UIColor.systemGray6).opacity(0.6))
            .cornerRadius(8)
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button(action: {
                Task {
                    let validSymptoms = symptoms
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    
                    if validSymptoms.isEmpty {
                        alertMessage = "Minimal harus ada satu keluhan pasien"
                        showingErrorAlert = true
                        return
                    }
                    
                    let trimmedDiagnostic = diagnostic.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let success = await viewModel.editPatientDetail(
                        fisioId: fisioId,
                        patientId: patient.id,
                        phase: selectedPhase,
                        symptoms: validSymptoms,
                        diagnostic: trimmedDiagnostic.isEmpty ? nil : trimmedDiagnostic
                    )

                    if success {
                        try? await viewModel.readPatientDetail(fisioId: fisioId, patientId: patient.id)
                        showingSuccessAlert = true
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
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -2)
    }
    
    private func patientHeaderSection(patient: Patient) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.black)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 26))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(patient.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(patient.gender == "Laki-laki" || patient.gender == "Laki - laki" ? "Laki - Laki" : patient.gender)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(UIColor.systemGray5))
                        )
                }
                
                Text(patient.phoneNumber + " | " + formatDate(patient.dateOfBirth))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
    private func therapyInfoSection(patient: Patient) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Text("Tanggal mulai terapi : \(formatDate(patient.therapyStartDate))")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(6)
    }
    
    private func getPhaseLabel(_ phase: Int) -> String {
        switch phase {
        case 1:
            return "(Pre-Op)"
        case 2, 3, 4:
            return "(Post-Op)"
        default:
            return ""
        }
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
