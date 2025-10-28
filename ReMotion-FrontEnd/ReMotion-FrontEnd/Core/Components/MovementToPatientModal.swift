//
//  MovementToPatientModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct MovementToPatientModal: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var selectedMovements: [Movement]
    @State private var showConfigModal = false
    @State private var selectedMovement: Movement?
    @State private var shouldDismiss = false
    
    let availableMovements: [Movement] = sampleMovements
    
    var filteredMovements: [Movement] {
        if searchText.isEmpty {
            return availableMovements
        }
        return availableMovements.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            searchSection
            exerciseGridSection
        }
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showConfigModal) {
            if let movement = selectedMovement {
                MovementConfigModal(
                    movement: movement,
                    selectedMovements: $selectedMovements,
                    dismissParent: $shouldDismiss
                )
            }
        }
        .onChange(of: shouldDismiss) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
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
            
            Text("Pilih Gerakan Latihan")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cari Gerakan")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                TextField("Quadriceps set", text: $searchText)
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
    
    // MARK: - Exercise Grid Section
    private var exerciseGridSection: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredMovements) { movement in
                    MovementSelectionCard(movement: movement)
                        .onTapGesture {
                            selectedMovement = movement
                            showConfigModal = true
                        }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    MovementToPatientModal(selectedMovements: .constant([]))
}
