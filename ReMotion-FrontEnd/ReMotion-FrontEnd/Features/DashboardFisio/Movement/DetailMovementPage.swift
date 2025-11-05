//
//  DetailMovement.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 24/10/25.
//

import SwiftUI

struct DetailMovementPage: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    let exerciseId: Int
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView(message: "Memuat detail gerakan...")
            } else if let movement = viewModel.exercise {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.4))
                            
                            Image(systemName: movement.video)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Putar Video")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(.black.opacity(0.3))
                            .cornerRadius(10)
                        }
                        .frame(height: 350)
                        .cornerRadius(12)
                        .padding(.bottom, 10)
                        
                        Text(movement.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 10) {
                            Label(movement.type, systemImage: "timer")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                            
                            Text(movement.muscle)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                        
                        Text(movement.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
            } else if viewModel.isError {
                ErrorView(message: viewModel.errorMessage)
            }
        }
        .navigationTitle("Detail Gerakan Latihan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        print("Edit Gerakan tapped")
                    }) {
                        Label("Edit Gerakan", systemImage: "square.and.pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Hapus Gerakan", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Konfirmasi Hapus", isPresented: $showingDeleteAlert) {
            Button("Hapus", role: .destructive) {
                Task {
                    let success = await viewModel.deleteExercise(exerciseId: exerciseId)
                    if success {
                        dismiss()
                    }
                }
            }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Apakah Anda yakin ingin menghapus gerakan ini? Tindakan ini tidak dapat dibatalkan.")
        }
        .onAppear {
            Task {
                try? await viewModel.readExerciseDetail(exerciseId: exerciseId)
            }
        }
    }
}
