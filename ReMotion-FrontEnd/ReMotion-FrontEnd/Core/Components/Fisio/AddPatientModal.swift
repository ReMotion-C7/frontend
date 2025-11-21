//
//  AddPatientModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 27/10/25.
//

import SwiftUI

struct AddPatientModal: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedPatient: ReadUsersNonFisioData?
    @State private var therapyStartDate = Date()
    @State private var symptoms: [String] = []
    @State private var inputs: [String] = [""]
    @State private var newSymptom = ""
    @State private var showDatePicker = false
    @State private var showSymptomInput = false
    @State private var phase: Int = 1
    @State private var diagnostic: String = ""
    @State private var showExitAlert = false
    
    let fisioId: Int
    
    @StateObject private var viewModel = PatientViewModel()
    
    var filteredPatients: [ReadUsersNonFisioData] {
        if searchText.isEmpty {
            return []
        }
        return viewModel.users.filter { patient in
            patient.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    let phaseOptions: [(id: Int, name: String)] = [
        (1, "Fase 1 (Post-Op)"),
        (2, "Fase 2 (Post-Op)"),
        (3, "Fase 3 (Post-Op)"),
        (4, "Fase 4 (Post-Op)"),
        (5, "Pre-Op"),
        (6, "Non-Op")
    ]
    
    struct PhasePickerView: View {
        @Binding var phase: Int
        let phaseOptions: [(id: Int, name: String)]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pilih fase pasien")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Menu {
                    ForEach(phaseOptions, id: \.id) { option in
                        Button(option.name) {
                            phase = option.id
                        }
                    }
                } label: {
                    HStack {
                        Text(phaseOptions.first(where: { $0.id == phase })?.name ?? "Pilih Fase")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var diagnosticSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Diagnosa pasien")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            TextField("Hasil diagnosa pasien", text: $diagnostic)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 15))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    func getFinalSymptoms() -> [String] {
        var finalSymptoms = symptoms
        let trimmedDraft = newSymptom.trimmingCharacters(in: .whitespaces)
        if !trimmedDraft.isEmpty {
            finalSymptoms.append(trimmedDraft)
        }
        return finalSymptoms
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    showExitAlert = true
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Tambah Pasien")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Color.clear
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            
            Divider()
            
            if viewModel.isLoading {
                LoadingView(message: "Mengambil data user...")
            }
            else if viewModel.errorMessage != "" {
                ErrorView(message: viewModel.errorMessage)
            }
            else {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Masukkan Nama Pasien")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HStack {
                                if selectedPatient != nil {
                                    Text(searchText)
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                } else {
                                    TextField("Nama Pasien", text: $searchText)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .font(.system(size: 15))
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                                .buttonStyle(.plain)
                                
                            }
                            .padding()
                            .background(Color.gray.opacity(selectedPatient != nil ? 0.05 : 0.1))
                            .cornerRadius(8)
                        }
                        
                        if !searchText.isEmpty && !filteredPatients.isEmpty && selectedPatient == nil {
                            VStack(spacing: 8) {
                                ForEach(filteredPatients) { patient in
                                    Button(action: {
                                        selectedPatient = patient
                                        searchText = patient.name
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(.black)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(patient.name)
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(.black)
                                                Text(patient.phoneNumber)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        if let patient = selectedPatient {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(patient.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.black)
                                    Text(patient.phoneNumber)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedPatient = nil
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tanggal Mulai Terapi")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    withAnimation {
                                        showDatePicker.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.black)
                                        
                                        Text(DateHelper.convertDateToStr(date: therapyStartDate))
                                            .font(.system(size: 15))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                                
                                if showDatePicker {
                                    DatePicker("", selection: $therapyStartDate, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding(.vertical, 8)
                                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Keluhan")
                                    .font(.headline)
                                if !symptoms.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(Array(symptoms.enumerated()), id: \.offset) { index, symptom in
                                                    HStack {
                                                        Text("• \(symptom)")
                                                            .foregroundColor(.secondary)
                                                        
                                                        Spacer()
                                                        Button(action: {
                                                            symptoms.remove(at: index)
                                                        }) {
                                                            Image(systemName: "trash")
                                                                .foregroundColor(.red)
                                                        }
                                                    }
                                                }
                                    }
                                }
                                TextField("Tambahkan keluhan", text: $newSymptom)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 15))
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    let trimmed = newSymptom.trimmingCharacters(in: .whitespaces)
                                    
                                    if !trimmed.isEmpty {
                                        symptoms.append(trimmed)
                                        newSymptom = ""
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        Text("Tambahkan keluhan baru")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                }
                            }
                            diagnosticSection
                            PhasePickerView(phase: $phase, phaseOptions: phaseOptions)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
            
            Button(action: {
                let finalSymptoms = getFinalSymptoms()
                Task {
                    guard let selectedPatient = selectedPatient else {
                        print("selectedPatient is nil")
                        return
                    }
                    
                    do {
                        try await viewModel.addPatient(
                            fisioId: fisioId,
                            userId: selectedPatient.id,
                            phaseId: phase,
                            therapyStartDate: DateHelper.convertDateToStr(date: therapyStartDate),
                            symptoms: finalSymptoms,
                            diagnostic: diagnostic
                        )
                        dismiss()
                    } catch {
                        print("Gagal menambahkan pasien: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Tambah Pasien")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                // --- MODIFIED CTA: Menggunakan GradientPurple saat aktif ---
                .background(
                    Group {
                        if selectedPatient != nil {
                            GradientPurple()
                        } else {
                            Color.gray.opacity(0.4)
                        }
                    }
                )
                .cornerRadius(8)
                // ----------------------------------------------------------
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .disabled(selectedPatient == nil)
        }
        .background(Color.white)
        .onAppear {
            Task {
                try await viewModel.readUsersNonFisio(fisioId: fisioId)
            }
        }
        .alert("Keluar Tanpa Menyimpan?", isPresented: $showExitAlert) {
            Button("Batal", role: .cancel) { }
            Button("Keluar", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Data yang Anda masukkan tidak akan disimpan. Apakah Anda yakin ingin keluar?")
        }
        .interactiveDismissDisabled()
    }
}
