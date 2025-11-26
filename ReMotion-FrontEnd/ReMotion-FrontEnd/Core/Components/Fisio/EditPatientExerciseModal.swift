//
//  EditPatientExerciseModal.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 03/11/25.
//

import SwiftUI

struct EditPatientExerciseModal: View {
    let exercise: Exercise
    @ObservedObject var viewModel: PatientViewModel
    @Binding var showEditModal: Bool
    
    @State private var setInput: String = ""
    @State private var repOrTimeInput: String = ""
    @State private var methodId: Int = 1
    
    init(exercise: Exercise, viewModel: PatientViewModel, showEditModal: Binding<Bool>) {
        self.exercise = exercise
        self.viewModel = viewModel
        self._showEditModal = showEditModal
        _setInput = State(initialValue: "\(exercise.set)")
        _repOrTimeInput = State(initialValue: "\(exercise.repOrTime)")
        _methodId = State(initialValue: exercise.type == "Waktu" ? 2 : 1)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showEditModal = false
                }
            
            VStack(spacing: 20) {
                headerSection
                exerciseImageSection
                exerciseInfoSection
                inputFieldsSection
                saveButton
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - UI Sections
extension EditPatientExerciseModal {
    
    private var headerSection: some View {
        HStack {
            Button(action: { showEditModal = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Edit Gerakan Pasien")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear.frame(width: 20, height: 20)
        }
    }
    
    private var exerciseImageSection: some View {
        ZStack {
            AsyncImage(url: URL(string: exercise.image)) { image in
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
            .frame(height: 200)
            .cornerRadius(16)
            .clipped()
        }
    }
    
    private var exerciseInfoSection: some View {
        VStack(spacing: 12) {
            Text(exercise.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
    }
    
    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
            MethodPickerView(method: $methodId, methodOptions: [
                (1, "Repetisi"),
                (2, "Waktu")
            ])

            InputField(
                title: "Masukkan Jumlah Set",
                placeholder: "5",
                text: $setInput,
                keyboardType: .numberPad
            )
            
            InputField(
                title: methodId == 2 ? "Masukkan Durasi Waktu (detik)" : "Masukkan Jumlah Rep",
                placeholder: methodId == 2 ? "30" : "10",
                text: $repOrTimeInput,
                keyboardType: .numberPad
            )
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            Task { await saveEditedExercise() }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray))
            } else {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Simpan Perubahan")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Group {
                        if isFormValid {
                            GradientPurple()
                                .cornerRadius(12)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.5))
                        }
                    }
                )
            }
        }
        .disabled(!isFormValid || viewModel.isLoading)
    }
}

extension EditPatientExerciseModal {
    private var isFormValid: Bool {
        if let _ = Int(setInput),
           let _ = Int(repOrTimeInput),
           !setInput.isEmpty,
           !repOrTimeInput.isEmpty {
            return true
        }
        return false
    }
    
    private func saveEditedExercise() async {
        guard let setValue = Int(setInput),
              let repOrTimeValue = Int(repOrTimeInput) else { return }
        
        guard let fisioId = viewModel.fisioId,
              let patientId = viewModel.patientId else {
            print("⚠️ Missing fisioId or patientId")
            return
        }
        
        showEditModal = false
        
        await viewModel.editPatientExercise(
            fisioId: fisioId,
            patientId: patientId,
            exerciseId: exercise.id,
            methodId: methodId,
            set: setValue,
            repOrTime: repOrTimeValue
        )
        
        if !viewModel.isError {
            try? await viewModel.readPatientDetail(fisioId: fisioId, patientId: patientId)
        }
    }
}
