//
//  DetailMovement.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 24/10/25.
//

import SwiftUI
import AVKit

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
                        if let videoURL = URL(string: movement.video) {
                            VideoPlayerView(videoURL: videoURL)
                                .frame(height: 350)
                                .cornerRadius(12)
                                .padding(.bottom, 10)
                        } else {
                            ZStack {
                                Rectangle().fill(Color.gray.opacity(0.4))
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "video.slash.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("Video tidak tersedia")
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
                        }
                        
                        Text(movement.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 10) {
                            Text(movement.muscle)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            
                            Rectangle()
                                .frame(width: 1, height: 20)
                                .foregroundColor(.gray.opacity(0.6))
                            
                            Text(movement.type)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray)
                                        .opacity(0.6)
                                )
                            
                            Text(movement.category)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray)
                                        .opacity(0.6)
                                )
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

#Preview {
    DetailMovementPage(
        viewModel: {
            let vm = ExerciseViewModel()
            vm.exercise = MovementDetail(
                id: 1,
                name: "Jumping Jacks",
                type: "AGA",
                category: "Keseimbangan",
                description: "Full-body exercise.",
                muscle: "Seluruh Tubuh",
                video: "https://example.com/jumping_jacks.jpg"
            )
            vm.isLoading = false
            return vm
        }(),
        exerciseId: 1
    )
}
