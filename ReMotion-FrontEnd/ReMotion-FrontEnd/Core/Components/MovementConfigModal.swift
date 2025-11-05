//
//  MovementConfigModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 26/10/25.
//

import SwiftUI

struct MovementConfigModal: View {
    let movement: Movement
    let patient: Patient
    @Binding var selectedExercises: [Exercise]
    @Binding var showConfigModal: Bool 
    @Binding var dismissParent: Bool
    
    @State private var setsInput: String = ""
    @State private var durationInput: String = ""
    
    init(movement: Movement, patient: Patient, selectedExercises: Binding<[Exercise]>, showConfigModal: Binding<Bool>, dismissParent: Binding<Bool>) {
        self.movement = movement
        self.patient = patient
        self._selectedExercises = selectedExercises
        self._showConfigModal = showConfigModal
        self._dismissParent = dismissParent
        
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showConfigModal = false
                }
            
            VStack(spacing: 20) {
                headerSection
                exerciseImageSection
                exerciseInfoSection
                inputFieldsSection
                addButton
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }

    private var headerSection: some View {
        HStack {
            Button(action: { showConfigModal = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Tambah Gerakan")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear
                .frame(width: 20, height: 20)
        }
    }
    
    private var exerciseImageSection: some View {
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
            .frame(height: 200)
            .cornerRadius(16)
            .clipped()
        }
    }
    
    private var exerciseInfoSection: some View {
        VStack(spacing: 12) {
            // Exercise name
            Text(movement.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                TagView(
                    text: movement.type,
                    icon: movement.type == "Waktu" ? "clock" : "repeat"
                )
                
                TagView(text: movement.muscle, icon: nil)
            }
        }
    }
    
    // MARK: - Input Fields Section (Modified)
    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
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
    
    private func addMovementWithConfig() {
        guard let sets = Int(setsInput),
              let repOrTime = Int(durationInput) else {
            return
        }

        let newExercise = Exercise(
            id: Int.random(in: 1000...9999),
            name: movement.name,
            type: movement.type,
            image: movement.image,
            muscle: movement.muscle,
            description: movement.description,
            set: sets,
            repOrTime: repOrTime
        )
        
        selectedExercises.append(newExercise)
        showConfigModal = false
        dismissParent = true
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

#Preview {
    // Preview the modal on top of a blurred background
    ZStack {
        Color.gray.opacity(0.5).ignoresSafeArea()
        
        MovementConfigModal(
            movement: sampleMovements[0], // "Waktu" type
            patient: samplePatients[0],
            selectedExercises: .constant([]),
            showConfigModal: .constant(true),
            dismissParent: .constant(false)
        )
    }
}
