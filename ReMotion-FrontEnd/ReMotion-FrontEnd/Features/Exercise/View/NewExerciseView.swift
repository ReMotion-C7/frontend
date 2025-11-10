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
    
    var body: some View {
        HStack {
            
            if let currentPhase = viewModel.newCurrentPhase {
                switch currentPhase {
                case .exercise(let details, let currentSet):
                    ExercisePhaseSidebar(currentVideoURL: currentVideoURL, onNext: viewModel.newGoToNextPhase)
                case .rest(let duration, let nextExercise):
                    RestPhaseSidebar(onNext: viewModel.newGoToNextPhase)
                }
                
            }
            
            ZStack {
                //                Text("Ini bagian video bang")
                QuickPoseCameraView(useFrontCamera: viewModel.useFrontCamera, delegate: viewModel.quickPose)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                QuickPoseOverlayView(overlayImage: $viewModel.overlayImage)
                
                
                if !viewModel.showModal {
                    VStack {
                        HStack {
                            ProgressView(value: (viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .scaleEffect(x: 1, y: 4, anchor: .center)
                                .padding(.horizontal, 32)
                                .frame(width: 500, height: 100)
                            Text("\(Int(((viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0) * 100))%")
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
                            .padding(.bottom, 8)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(Color.white)
                        Text("Mundur sedikit ke belakang sehingga seluruh tubuh mulai dari ujung kepala hingga ujung kaki terlihat.")
                            .font(.subheadline)
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
                viewModel.newStartSession(with: exercises)
            }
            .onDisappear {
                viewModel.quickPose.stop()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
}

struct RestPhaseSidebar: View {
    
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("Lunges")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("00:00:30")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                print("Selanjutnya tapped")
                onNext()

            }) {
                HStack {
                    Image(systemName: "play.fill") // SF Symbol
                    Text("Selanjutnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(Color(.sRGB, white: 0.15, opacity: 1))
                .cornerRadius(16)
            }
            
            Button(action: {
                print("Ulangi tapped")
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Ulangi")
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
    }
}

struct ExercisePhaseSidebar: View {
    
    let currentVideoURL: URL?
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("Lunges")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Otot Paha Depan")
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
            
            Text("Set: 1/10")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("30x")
                .font(.system(size: 64))
                .fontWeight(.bold)
            
            Button(action: {
                print("Selanjutnya tapped")
                onNext()
            }) {
                HStack {
                    Image(systemName: "play.fill") // SF Symbol
                    Text("Selanjutnya")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.subheadline)
                .frame(maxWidth: 320)
                .padding()
                .background(Color(.sRGB, white: 0.15, opacity: 1))
                .cornerRadius(16)
            }
            
            Button(action: {
                print("Ulangi tapped")
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Ulangi")
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
    }
}
