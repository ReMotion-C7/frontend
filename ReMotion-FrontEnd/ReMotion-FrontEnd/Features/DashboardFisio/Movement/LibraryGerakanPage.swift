//
//  LibraryGerakanPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import SwiftUI

struct LibraryGerakanPage: View {
    
    @StateObject private var viewModel = ExerciseViewModel()
    @StateObject private var patientViewModel = PatientViewModel()
    @State private var showDeleteModal = false
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        GeometryReader { geometry in
            
            if viewModel.isLoading {
                LoadingView(message: "Memuat semua gerakan...")
            } else if viewModel.errorMessage != "" {
                ErrorView(message: "Gagal memuat gerakan latihan.")
            }
            else {
                ScrollView {
                    let availableWidth = geometry.size.width // padding
                    let itemWidth: CGFloat = 244
                    let spacing: CGFloat = 30
                    let columnsCount = max(Int(availableWidth / (itemWidth + spacing)), 1)
                    
                    // Buat grid layout dinamis
                    let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
                    
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(viewModel.exercises) { move in
                            NavigationLink(destination:  DetailMovementPage(viewModel: viewModel, exerciseId: move.id)) {
                                DashboardCardSmall(movement: move)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
        .overlay {
            if showDeleteModal {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                DeleteModal(
                    showDeleteModal: $showDeleteModal,
                    exerciseName: selectedExercise?.name ?? "Gerakan",
                    onConfirm: {
                        if let selected = selectedExercise {
                            //                            Task {
                            //                                await viewModel.deleteExercise(id: selected.id)
                            //                                await viewModel.readExercises()
                            //                            }
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear {
            Task {
                try await viewModel.readExercises()
            }
        }
    }
}

//#Preview {
//    LibraryGerakanPage()
//}
