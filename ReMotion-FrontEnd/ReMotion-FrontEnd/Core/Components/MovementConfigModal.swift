//
//  MovementConfigModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 26/10/25.
//

import SwiftUI

struct MovementConfig {
    var sets: String = ""
    var duration: String = ""
}

struct MovementConfigModal: View {
    @Environment(\.dismiss) var dismiss
    let movement: Movement
    @Binding var selectedMovements: [Movement]
    @Binding var dismissParent: Bool
    
    @State private var selectedTab: ConfigTab = .repetisi
    @State private var setsInput: String = ""
    @State private var durationInput: String = ""
    
    enum ConfigTab {
        case repetisi
        case otherMuscle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            patientInfoSection
            Divider()
            
            ScrollView {
                VStack(spacing: 24) {
                    exerciseImageSection
                    tabSelector
                    inputFieldsSection
                    addButton
                }
                .padding(.vertical, 24)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text("Exercise Movement Detail")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    // MARK: - Patient Info Section
    private var patientInfoSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.gray)
            
            Text("Daniel Fernando")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
    }
    
    // MARK: - Exercise Image Section
    private var exerciseImageSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 220)
                
                Image(systemName: movement.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 180)
                    .foregroundColor(.gray.opacity(0.3))
            }
            
            Text(movement.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 8) {
            TabButton(
                title: "Repetisi",
                isSelected: selectedTab == .repetisi,
                action: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .repetisi } }
            )
            
            TabButton(
                title: movement.category,
                isSelected: selectedTab == .otherMuscle,
                action: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .otherMuscle } }
            )
        }
        .padding(4)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Input Fields Section
    private var inputFieldsSection: some View {
        VStack(spacing: 20) {
            InputField(
                title: "Masukkan Jumlah Set",
                placeholder: "Contoh: 15",
                text: $setsInput,
                keyboardType: .numberPad
            )
            
            InputField(
                title: movement.label == "Waktu" ? "Masukkan Durasi Waktu (detik)" : "Masukkan Jumlah Rep",
                placeholder: movement.label == "Waktu" ? "Contoh: 30" : "Contoh: 10",
                text: $durationInput,
                keyboardType: .numberPad
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button(action: addMovementWithConfig) {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                Text("Tambah Gerakan")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private func addMovementWithConfig() {
        selectedMovements.append(movement)
        dismiss()
        dismissParent = true
    }
}

// MARK: - Input Field Component
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
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.black : Color.clear)
                )
        }
    }
}

#Preview {
    MovementConfigModal(
        movement: sampleMovements[0],
        selectedMovements: .constant([]),
        dismissParent: .constant(false)
    )
}
