//
//  ExerciseSessionView.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//


import SwiftUI

struct ExerciseSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ExerciseSessionViewModel()
    @State private var showExitModal = false
    let exercises: [Exercises]
    
    private var currentVideoURL: URL? {
        guard let currentPhase = viewModel.currentPhase else { return nil }
        
        let urlString: String
        switch currentPhase {
        case .exercise(let details, _):
            urlString = details.video
        case .rest(_, let nextExercise):
            urlString = nextExercise.video
        }
        
        return URL(string: urlString)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if let currentPhase = viewModel.currentPhase {
                    switch currentPhase {
                    case .exercise(let details, let currentSet):
                        ExerciseView(
                            geometry: geometry,
                            exerciseDetails: details,
                            currentSet: currentSet,
                            onNext: viewModel.goToNextPhase,
                            onPrevious: viewModel.goToPreviousPhase
                        )
                    case .rest(let duration, let nextExercise):
                        RestView(
                            geometry: geometry,
                            duration: duration,
                            nextExercise: nextExercise,
                            onNext: viewModel.goToNextPhase,
                            onPrevious: viewModel.goToPreviousPhase
                        )
                    }
                } else {
                    ProgressView()
                }
                
                ZStack {
                    if let url = currentVideoURL {
                        VideoPlayerView(videoURL: url)
                    } else {
                        Color.black
                        Text("Loading Video...")
                            .foregroundColor(.white)
                    }
                }
                .frame(width: geometry.size.width * 0.6)
                .background(Color.black)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                showExitModal = true
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.title2)
            })
            .ignoresSafeArea()
            .onAppear {
                viewModel.startSession(with: exercises)
            }
            .alert("Apakah Anda Yakin Ingin Keluar?", isPresented: $showExitModal) {
                Button("Keluar", role: .destructive) {
                    dismiss()
                }
                Button("Batal", role: .cancel) { }
            }
            .alert("Latihan Selesai!", isPresented: $viewModel.isSessionFinished) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}


struct WorkoutSessionView_Previews: PreviewProvider {
    static let dummyExercises: [Exercises] = [
        Exercises(
            id: 1,
            name: "Squat",
            type: "Repetition",
            video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/Squat%20Landscape.mp4",
            muscle: "Quadriceps",
            set: 3,
            repOrTime: 10
        ),
        Exercises(
            id: 2,
            name: "Lunges",
            type: "Repetisi",
            video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/Lunges%20Landscape.mp4",
            muscle: "Quadriceps",
            set: 3,
            repOrTime: 10
        ),
        Exercises(
            id: 3,
            name: "Single Leg Balance",
            type: "Waktu",
            video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/One%20Leg%20Balance%20Landscape.mp4",
            muscle: "Whole Legs Balance",
            set: 3,
            repOrTime: 10
        )
    ]
    
    static var previews: some View {
        ExerciseSessionView(exercises: dummyExercises)
    }
}
