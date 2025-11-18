//
//  MovementToPatientModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

fileprivate enum ModalStep {
    case selection
    case config
}

struct MovementToPatientModal: View {
    @State private var searchText = ""
    @Binding var selectedExercises: [Exercise]
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ExerciseViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    @Binding var dismissSheet: Bool
    
    let patient: Patient
    let fisioId: Int
    @State private var currentStep: ModalStep = .selection
    @State private var selectedExercise: ModalExercise? = nil
    @State private var showSelectionExitAlert = false
    @State private var showConfigExitAlert = false
    @State private var setsInput: String = ""
    @State private var durationInput: String = ""
    @State private var selectedType: String? = nil
    @State private var selectedCategory: String? = nil
    @State private var method: Int = 1
    
    let methodOptions: [(id: Int, name: String)] = [
        (1, "Repetisi"),
        (2, "Waktu")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Divider()
            
            switch currentStep {
            case .selection:
                selectionBody
            case .config:
                configBody
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            Task {
//                await viewModel.readModalExercises()
                try await viewModel.readExercises()
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            Task {
//                await viewModel.readModalExercises(name: newValue)
                await viewModel.loadAllModalExercises()
            }
        }
        .interactiveDismissDisabled()
        .alert("Tutup Pemilihan Gerakan?", isPresented: $showSelectionExitAlert) {
            Button("Batal", role: .cancel) { }
            Button("Tutup", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Anda belum memilih gerakan. Apakah Anda yakin ingin menutup?")
        }
        
        .alert("Batalkan Menambah Gerakan?", isPresented: $showConfigExitAlert) {
            Button("Batal", role: .cancel) { }
            Button("Kembali", role: .destructive) {
                currentStep = .selection
                clearConfigInputs()
            }
        } message: {
            Text("Perubahan yang Anda masukkan tidak akan disimpan. Apakah Anda yakin ingin kembali?")
        }
        .animation(.default, value: currentStep)
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                if currentStep == .selection {
                    showSelectionExitAlert = true
                } else {
                    showConfigExitAlert = true
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(currentStep == .selection ? "Pilih Gerakan Latihan" : "Tambah Gerakan")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    @ViewBuilder
    private var selectionBody: some View {
        searchSection
        categorySection
        exerciseGridSection
    }
    
    @ViewBuilder
    private var configBody: some View {
        if let exercise = selectedExercise {
            ScrollView {
                VStack(spacing: 20) {
                    exerciseImageSection(for: exercise)
                    inputFieldsSection(for: exercise)
                    addButton
                }
                .padding(24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                clearConfigInputs()
            }
        } else {
            Text("Error: Gerakan tidak ditemukan.")
                .padding()
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cari Gerakan")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                TextField("Contoh: Quadriceps set", text: $searchText)
                    .font(.system(size: 15))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
    }
    
    private var categorySection: some View {
        VStack() {
            HStack(spacing: 12) {
                filterButton(
                    title: "AGA",
                    isSelected: selectedType == "AGA"
                ) {
                    toggleType("AGA")
                }
                
                filterButton(
                    title: "AGB",
                    isSelected: selectedType == "AGB"
                ) {
                    toggleType("AGB")
                }
                
                filterButton(
                    title: "Keseimbangan",
                    isSelected: selectedCategory == "Keseimbangan"
                ) {
                    toggleCategory("Keseimbangan")
                }
                
                filterButton(
                    title: "Penguatan",
                    isSelected: selectedCategory == "Penguatan"
                ) {
                    toggleCategory("Penguatan")
                }
                Spacer()
            }
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 20)
    }
    
    private func applyFilter() {
        Task {
//            await viewModel.readModalExercises(
//                name: searchText,
//                type: selectedType,
//                category: selectedCategory
//            )
            viewModel.filterModalExercises(name: searchText, type: selectedType, category: selectedCategory)
        }
    }
    
    private func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black.opacity(0.8))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                )
        }
    }
    
    func toggleType(_ type: String) {
        if selectedType == type {
            selectedType = nil
        } else {
            selectedType = type
        }
        applyFilter()
    }
    
    func toggleCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
        applyFilter()
    }
    
    private var exerciseGridSection: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Memuat Gerakan...")
                    .padding(.top, 50)
            }
            else if viewModel.modalExercises.isEmpty && (!searchText.isEmpty || selectedType != nil || selectedCategory != nil) {
                Text("Gerakan tidak ditemukan dengan kriteria yang Anda masukkan.")
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
            
            else if viewModel.modalExercises.isEmpty {
                Text("Tidak ada gerakan yang tersedia.")
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
            
            else {
                VStack {
                    ForEach(viewModel.modalExercises) { exercise in
                        MovementSelectionCard(
                            name: exercise.name,
                            type: exercise.type,
                            muscle: exercise.muscle,
                            imageSource: .url(exercise.image)
                        )
                        .onTapGesture {
                            selectedExercise = exercise
                            currentStep = .config
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func exerciseImageSection(for movement: ModalExercise) -> some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: movement.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "figure.walk")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                    )
            }
            
            VStack(spacing: 12) {
                Text(movement.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                TagView(text: movement.muscle, icon: nil)
            }
            .frame(height: 200)
            .cornerRadius(16)
            .clipped()
        }
    }
    
    private func inputFieldsSection(for movement: ModalExercise) -> some View {
        VStack(spacing: 16) {
            MethodPickerView(method: $method, methodOptions: methodOptions)
            
            InputField(
                title: "Masukkan Jumlah Set",
                placeholder: "5",
                text: $setsInput,
                keyboardType: .numberPad
            )
            
            InputField(
                title: movement.type == "Waktu" ? "Masukan Durasi Waktu (detik)" : "Masukkan Jumlah Rep",
                placeholder: movement.type == "Waktu" ? "30" : "10",
                text: $durationInput,
                keyboardType: .numberPad
            )
        }
    }
    
    private var addButton: some View {
        Button(action: addMovementWithConfig) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                Text("Tambah Gerakan")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isFormValid ? Color.black : Color.gray.opacity(0.5))
            )
        }
        .disabled(!isFormValid)
    }
    
    
    private var isFormValid: Bool {
        !setsInput.isEmpty && !durationInput.isEmpty &&
        Int(setsInput) != nil && Int(durationInput) != nil
    }
    
    private func clearConfigInputs() {
        setsInput = ""
        durationInput = ""
    }
    
    private func addMovementWithConfig() {
        guard let sets = Int(setsInput),
              let repOrTime = Int(durationInput),
              let exerciseId = selectedExercise?.id else {
            return
        }
        
        Task {
            await patientViewModel.assignPatientExercise(
                fisioId: fisioId,
                patientId: patient.id,
                exerciseId: exerciseId,
                methodId: method,
                set: sets,
                repOrTime: repOrTime
            )
            
            if !patientViewModel.isError {
                try? await patientViewModel.readPatientDetail(fisioId: fisioId, patientId: patient.id)
                
                await MainActor.run {
                    dismissSheet = true
                    dismiss()
                }
            }
        }
    }
}

struct TagView: View {
    let text: String
    let icon: String?
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 12))
            }
            Text(text)
                .font(.system(size: 13, weight: .medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .foregroundColor(.black.opacity(0.8))
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.15))
        )
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .font(.system(size: 15))
                .padding(16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

struct MethodPickerView: View {
    @Binding var method: Int
    let methodOptions: [(id: Int, name: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pilih Tipe Latihan (Repetisi/Durasi)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Menu {
                ForEach(methodOptions, id: \.id) { option in
                    Button(option.name) {
                        method = option.id
                    }
                }
            } label: {
                HStack {
                    Text(methodOptions.first(where: { $0.id == method })?.name ?? "Pilih Metode")
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
