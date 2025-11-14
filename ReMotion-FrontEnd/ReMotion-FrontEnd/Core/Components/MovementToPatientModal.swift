//
//  MovementToPatientModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct MovementToPatientModal: View {
    @State private var searchText = ""
    @Binding var selectedExercises: [Exercise]
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ExerciseViewModel()
    @ObservedObject var patientViewModel: PatientViewModel
    @Binding var dismissSheet: Bool
    
    let patient: Patient
    let fisioId: Int
    @State private var selectedExercise: ModalExercise? = nil
    @State private var showConfigModal = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            searchSection
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Memuat Gerakan...")
                Spacer()
            } else if viewModel.isError {
                Spacer()
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                exerciseGridSection
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            Task {
                await viewModel.readModalExercises()
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            Task {
                await viewModel.readModalExercises(name: newValue)
            }
        }
    }
    
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
    
    private var exerciseGridSection: some View {
        ScrollView {
            if viewModel.modalExercises.isEmpty && !searchText.isEmpty {
                Text("Gerakan \"\(searchText)\" tidak ditemukan.")
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(viewModel.modalExercises) { exercise in
                        ModalMovementSelectionCard(exercise: exercise)
                            .onTapGesture {
                                selectedExercise = exercise
                                showConfigModal = true
                            }
                    }
                }
                .padding(20)
            }
        }
        .sheet(isPresented: $showConfigModal) {
            if let exercise = selectedExercise {
                MovementConfigModal(
                    movement: exercise,
                    patient: patient,
                    fisioId: fisioId,
                    selectedExercises: $selectedExercises,
                    showConfigModal: $showConfigModal,
                    dismissSheet: $dismissSheet,
                    patientViewModel: ObservedObject(initialValue: patientViewModel)
                )
            }
        }
    }
}

struct ModalMovementSelectionCard: View {
    let exercise: ModalExercise
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: exercise.image)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.3))
                default:
                    ZStack {
                        Color.clear
                        ProgressView()
                    }
                }
            }
            .frame(height: 120)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                HStack {
                    Text(exercise.type)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(exercise.muscle)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
