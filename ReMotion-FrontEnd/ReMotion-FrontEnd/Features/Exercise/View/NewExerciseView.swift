//
//  NewExerciseView.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 03/11/25.
//

import SwiftUI
import QuickPoseSwiftUI
import QuickPoseCore

struct NewExerciseView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var showExitModal: Bool = false
    @StateObject var viewModel = NewExerciseViewModel()
    
    let exercises: [NewExercises]
    let patientId: Int
    
    private var currentVideoURL: URL? {
        guard let currentPhase = viewModel.newCurrentPhase else { return nil }
        
        let urlString: String
        switch currentPhase {
        case .exercise(let details, _):
            urlString = details.video
        case .rest(_, let nextExercise):
            urlString = nextExercise.video
        }
        
        return URL(string: urlString)
    }
    
    private var isLastPhase: Bool {
        viewModel.currentPhaseIndex == viewModel.workoutPhases.count - 1
    }
    
    var body: some View {
        HStack {
            if let currentPhase = viewModel.newCurrentPhase {
                switch currentPhase {
                    //                 case .exercise(let details, let currentSet):
                case .exercise(let exercise, let currentSet):
                    ExercisePhaseSidebar(
                        exercise: exercise,
                        currentSet: currentSet,
                        currentVideoURL: currentVideoURL,
                        onNext: {
                            // This closure now handles both "Next" and "Finish"
                            if isLastPhase {
                                Task {
                                    await viewModel.finishSession(patientId: patientId)
                                    dismiss() // Redirect back to SessionPage
                                }
                            } else {
                                viewModel.newGoToNextPhase()
                            }
                        },
                        onPrevious: viewModel.newGoToPreviousPhase,
                        viewModel: viewModel,
                        isLastPhase: isLastPhase, // <-- PASS THE NEW BOOLEAN
                        startCountdown: { value in
                            viewModel.startCountdown(from: value)
                        }
                    )
                    ExercisePhaseCamera(viewModel: viewModel, exercises: exercises)
                    
                case .rest(let duration, let nextExercise):
                    RestPhaseSidebar(
                        duration: duration,
                        onNext: viewModel.newGoToNextPhase,
                        onPrevious: viewModel.newGoToPreviousPhase,
                        onAddTime: viewModel.addRestTime,
                        viewModel: viewModel
                    )
                    
                    if let url = currentVideoURL {
                        VideoPlayerView(videoURL: url)
                            .overlay(
                                ZStack(alignment: .leading) {
                                    Color.black.opacity(0.8)   // dimming layer
                                    VStack(alignment: .leading) {
                                        Text("Gerakan selanjutnya...")
                                            .font(.system(size: 36))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 12)
                                        Text(nextExercise.name)
                                            .font(.system(size: 64))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 6)
                                        Text(nextExercise.muscle)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 32)
                                            .background(
                                                Capsule()
                                                    .fill(Color.white)
                                            )
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: "arrow.counterclockwise")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.white)
                                                Text(nextExercise.setInfo)
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.black.opacity(0.25))
                                            .cornerRadius(20)
                                            HStack(spacing: 8) {
                                                Image(systemName: "arrow.counterclockwise")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.white)
                                                
                                                Text("15x Set")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.black.opacity(0.25))
                                            .cornerRadius(20)
                                            
                                        }
                                        ProgressView()
                                    }
                                    .padding(.leading, 48)
                                }
                            )
                    }
                    
                }
                
            }
            
            //            ExercisePhaseCamera(viewModel: viewModel, exercises: exercises)
            
            //            ZStack {
            //                QuickPoseCameraView(useFrontCamera: viewModel.useFrontCamera, delegate: viewModel.quickPose)
            //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                QuickPoseOverlayView(overlayImage: $viewModel.overlayImage)
            //
            //
            //                if !viewModel.showModal {
            //                    VStack {
            //                        HStack {
            //                            ProgressView(value: (viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0)
            //                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            //                                .scaleEffect(x: 1, y: 4, anchor: .center)
            //                                .padding(.horizontal, 32)
            //                                .frame(width: 500, height: 100)
            //                            Text("\(Int(((viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0) * 100))%")
            //                                .font(.largeTitle)
            //                                .fontWeight(.bold)
            //                                .padding(.horizontal, 32)
            //                        }
            //                        .background(
            //                            RoundedRectangle(cornerRadius: 16)
            //                                .fill(Color.white)
            //                        )
            //                        Spacer()
            //                    }
            //                    .padding(.top, 64)
            //                }
            //
            //                if viewModel.showModal {
            //                    VStack {
            //                        Text("Beberapa bagian tubuh masih tidak terlihat")
            //                            .padding(.bottom, 8)
            //                            .font(.headline)
            //                            .bold()
            //                            .foregroundStyle(Color.white)
            //                        Text("Mundur sedikit ke belakang sehingga seluruh tubuh mulai dari ujung kepala hingga ujung kaki terlihat.")
            //                            .font(.subheadline)
            //                            .foregroundStyle(Color.white)
            //                    }
            //                    .padding()
            //                    .background(
            //                        RoundedRectangle(cornerRadius: 16)
            //                            .fill(Color.red)
            //                    )
            //                }
            //
            //            }
            //            .allowsHitTesting(false)
            //            .onAppear {
            //                viewModel.quickPoseSetup()
            //                viewModel.newStartSession(with: exercises)
            //            }
            //            .onDisappear {
            //                viewModel.quickPose.stop()
            //            }
            //            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            viewModel.showExitModal = true
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.title2)
        })
        .ignoresSafeArea()
        .alert("Apakah Anda Yakin Ingin Keluar?", isPresented: $viewModel.showExitModal) {
            Button("Keluar", role: .destructive) {
                dismiss()
            }
            Button("Batal", role: .cancel) {
                viewModel.showExitModal = false
            }
        }
        .onAppear {
            viewModel.newStartSession(with: exercises)
        }
    }
}

struct ExercisePhaseCamera: View {
    
    @ObservedObject var viewModel: NewExerciseViewModel
    let exercises: [NewExercises]
    
    var body: some View {
        ZStack {
            QuickPoseCameraView(useFrontCamera: viewModel.useFrontCamera, delegate: viewModel.quickPose)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            QuickPoseOverlayView(overlayImage: $viewModel.overlayImage)
            
            
            if !viewModel.showModal {
                VStack {
                    HStack {
                        //                        ProgressView(value: (viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0)
                        ProgressView(value: viewModel.averageJointScore)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                            .padding(.horizontal, 32)
                            .frame(width: 500, height: 100)
                        //                        Text("\(Int(((viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0) * 100))%")
                        Text("\(Int(viewModel.averageJointScore * 100))%")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal, 32)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    Spacer()
                }
                .padding(.top, 64)
            }
            
            if viewModel.showModal {
                VStack {
                    Text("Beberapa bagian tubuh masih tidak terlihat")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                        .font(.system(size: 72))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.red)
                )
            }
            
        }
        .allowsHitTesting(false)
        .onAppear {
            viewModel.quickPoseSetup()
            //            viewModel.newStartSession(with: exercises)
        }
        .onChange(of: viewModel.showModal) { sound in
            if sound {
                print("PLAY SOUND")
                viewModel.playSound(named: "yobel_kurang_mundur")
            }
        }
        .onDisappear {
            viewModel.quickPose.stop()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct RestPhaseSidebar: View {
    
    let duration: TimeInterval
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onAddTime: (Int) -> Void
    @ObservedObject var viewModel: NewExerciseViewModel
    
    var body: some View {
        VStack {
            Text("Istirahat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(viewModel.formattedRemainingTime)")
                .font(.system(size: 64))
                .fontWeight(.bold)
            
            Button(action: {
                print("+20d tapped")
                onAddTime(20)
            }) {
                Text("+20 detik")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .frame(maxWidth: 320)
                    .padding()
                    .background(Color(.sRGB, white: 0.15, opacity: 1))
                    .cornerRadius(16)
            }
            .padding(.bottom, 80)
            
            Button(action: {
                print("Selanjutnya tapped")
                onNext()
            }) {
                HStack {
                    Image(systemName: "arrow.forward")
                    Text("Selanjutnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(GradientPurple())
                .cornerRadius(16)
            }
            
            Button(action: {
                print("Sebelumnya tapped")
                onPrevious()
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                    Text("Sebelumnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(Color(.sRGB, white: 0.15, opacity: 1))
                .cornerRadius(16)
            }
        }
        .frame(maxWidth: 400, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            viewModel.startCountdown(from: Int(duration))
        }
    }
}

struct ExercisePhaseSidebar: View {
    
    let exercise: NewExercises
    let currentSet: Int
    let currentVideoURL: URL?
    let onNext: () -> Void
    let onPrevious: () -> Void
    let viewModel: NewExerciseViewModel
    let isLastPhase: Bool
    let startCountdown: (Int) -> Void
    
    var body: some View {
        VStack {
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(exercise.muscle)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black)
                .clipShape(Capsule())
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.white)
            
            HStack {
                if let url = currentVideoURL {
                    VideoPlayerView(videoURL: url)
                        .frame(maxWidth: 380, maxHeight: 300)
                        .cornerRadius(16)
                }
            }
            .padding(.vertical, 24)
            
            Text(exercise.method)
            
            Text("\(currentSet) / \(exercise.set)")
                .font(.title2)
                .fontWeight(.semibold)
            
            if(exercise.method != "Waktu") {
                Text("\(exercise.repOrTime)x")
                    .font(.system(size: 64))
                    .fontWeight(.bold)
            } else {
                Text("\(viewModel.formattedRemainingTime)")
                    .font(.system(size: 64))
                    .fontWeight(.bold)
            }
            
            Button(action: {
                print(isLastPhase ? "Selesai Latihan tapped" : "Selanjutnya tapped")
                onNext()
            }) {
                HStack {
                    Image(systemName: isLastPhase ? "checkmark.circle.fill" : "arrow.forward")
                    Text(isLastPhase ? "Selesai Latihan" : "Selanjutnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(GradientPurple())
                .cornerRadius(16)
            }
            
            Button(action: {
                print("Sebelumnya tapped")
                onPrevious()
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                    Text("Sebelumnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(Color(.sRGB, white: 0.15, opacity: 1))
                .cornerRadius(16)
            }
            
            
        }
        .frame(maxWidth: 400, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            if exercise.method == "Waktu" {
                startCountdown(exercise.repOrTime)
            }
        }
    }
}
