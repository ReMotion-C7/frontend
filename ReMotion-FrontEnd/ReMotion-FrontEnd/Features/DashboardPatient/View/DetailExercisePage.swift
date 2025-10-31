//
//  DetailExercisePage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI
import AVKit

struct DetailExercisePage: View {

    let userId: Int
    let exerciseId: Int
    @ObservedObject var viewModel: SessionViewModel
    
    @State private var player: AVPlayer?

    // Computed property to get icon based on type
    private func typeIcon(for exercise: SessionExerciseDetail) -> String {
        switch exercise.type.lowercased() {
        case "waktu":
            return "clock"
        case "repetisi":
            return "arrow.counterclockwise"
        default:
            return "figure.strengthtraining.traditional"
        }
    }
    
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                LoadingView(message: "Memuat detail gerakan...")
            }
            else if viewModel.errorMessage != "" {
                ErrorView(message: "Gagal memuat detail gerakan.")
            }
            else if let exercise = viewModel.sessionExercise {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Image/Video
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.4))
//                                .cornerRadius(12)
//                            
//                            VStack(spacing: 8) {
//                                Image(systemName: "play.circle.fill")
//                                    .font(.system(size: 60))
//                                    .foregroundColor(.white.opacity(0.8))
//                                
//                                Text("Putar Video")
//                                    .font(.caption)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.white)
//                            }
//                            .padding()
//                            .background(.black.opacity(0.3))
//                            .cornerRadius(10)
//                        }
//                        .frame(height: 300)
//                        .padding(.bottom, 10)
                        
                        ZStack {
                            if let videoString = viewModel.sessionExercise?.video,
                               let videoURL = URL(string: videoString),
                               UIApplication.shared.canOpenURL(videoURL) {

                                VideoPlayerView(videoURL: videoURL)
                                    .cornerRadius(12)
                                    .transition(.opacity)
                            } else {
                                ZStack {
                                    Color.black
                                    VStack(spacing: 8) {
                                        ProgressView()
                                            .tint(.white)
                                        Text("Loading video...")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .frame(height: 500)
                        .background(Color.black)
                        .cornerRadius(12)
                        .animation(.easeInOut, value: viewModel.sessionExercise?.video)
                        
                        // Name
                        HStack {
                            Text(exercise.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // Type
                            HStack(spacing: 6) {
                                Image(systemName: typeIcon(for: exercise))
                                    .font(.callout)
                                Text(exercise.type)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.15))
                            .foregroundColor(.gray)
                            .cornerRadius(8)
                        }
                        
                        // Muscle
                        HStack(spacing: 10) {
                            Text(exercise.muscle)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        .font(.callout)
                        
                        // Set and repOrTime
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("\(exercise.set)x Set")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            
                            HStack(spacing: 4) {
                                Image(systemName: exercise.type.lowercased() == "waktu" ? "clock" : "arrow.counterclockwise")
                                Text(exercise.type.lowercased() == "waktu"
                                     ? "\(exercise.repOrTime) Detik"
                                     : "\(exercise.repOrTime)x Repetisi")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        
                        // Description
                        Text(exercise.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(false)
            }
        }
        .onAppear {
            Task {
                try await viewModel.readSessionExerciseDetail(patientId: userId, exerciseId: exerciseId)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        DetailExercisePage(exercise: samplePatients[0].exercises[0])
//    }
//}
