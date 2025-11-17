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
    @State private var isPlaying = true
    @State private var isVideoReady = false
    
    // Computed property to get icon based on type
    private func typeIcon(for exercise: SessionExerciseDetailV2) -> String {
        switch exercise.method.lowercased() {
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
                        ZStack {
                            if let videoString = viewModel.sessionExercise?.video,
                               let videoURL = URL(string: videoString),
                               UIApplication.shared.canOpenURL(videoURL) {
                                
                                ZStack {
                                    VideoPlayerView(videoURL: videoURL, isPlaying: $isPlaying)
                                        .cornerRadius(12)
                                        .allowsHitTesting(false)
                                        .onAppear {
                                            isVideoReady = false
                                            let player = AVPlayer(url: videoURL)
                                            player.currentItem?.asset.loadValuesAsynchronously(forKeys: ["playable"]) {
                                                var error: NSError? = nil
                                                let status = player.currentItem?.asset.statusOfValue(forKey: "playable", error: &error)
                                                DispatchQueue.main.async {
                                                    if status == .loaded {
                                                        isVideoReady = true
                                                    } else {
                                                        isVideoReady = false
                                                    }
                                                }
                                            }
                                        }
                                    
                                    // Overlay transparan untuk tap gesture
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPlaying.toggle()
                                        }
                                    
                                    // Overlay play icon
                                    if !isPlaying {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 80))
                                            .foregroundColor(.white.opacity(0.85))
                                            .transition(.opacity)
                                    }
                                    
                                    // Overlay loading video
                                    if !isVideoReady {
                                        VStack(spacing: 8) {
                                            ProgressView()
                                                .tint(.white)
                                            Text("Loading video...")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(10)
                                    }
                                }
                                .frame(height: 500)
                                .background(Color.black)
                                .cornerRadius(12)
                                .animation(.easeInOut, value: isPlaying)
                                
                            } else {
                                // fallback jika URL invalid
                                ZStack {
                                    Color.black
                                    VStack(spacing: 8) {
                                        ProgressView()
                                            .tint(.white)
                                        Text("Memuat video...")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                                .frame(height: 500)
                                .cornerRadius(12)
                            }
                        }
                        // Name
                        HStack {
                            Text(exercise.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // Type
                            HStack(spacing: 6) {
                                Image(systemName: typeIcon(for: exercise))
                                    .font(.callout)
                                Text(exercise.method)
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
                                Image(systemName: exercise.method.lowercased() == "waktu" ? "clock" : "arrow.counterclockwise")
                                Text(exercise.method.lowercased() == "waktu"
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
            isVideoReady = false
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
