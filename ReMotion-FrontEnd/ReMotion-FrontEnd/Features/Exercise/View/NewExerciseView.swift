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
    
    @StateObject var viewModel = NewExerciseViewModel()
    
    private var videoURL: String = "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/Lunges%20Landscape.mp4"
    
    var body: some View {
        HStack {
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
                    if let url = URL(string: videoURL) {
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
            
            ZStack {
                //                Text("Ini bagian video bang")
                QuickPoseCameraView(useFrontCamera: viewModel.useFrontCamera, delegate: viewModel.quickPose)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                QuickPoseOverlayView(overlayImage: $viewModel.overlayImage)
                
                VStack {
                    ProgressView(value: (viewModel.leftKneeScore + viewModel.rightKneeScore) / 2.0)
                        .padding(32)
                        .frame(width:400, height: 100)
                    
//                    Text("\(viewModel.leftKneeScore)")
//                    Text("\(viewModel.rightKneeScore)")
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )                
                
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
            .onAppear(perform: viewModel.quickPoseSetup)
            .onDisappear {
                viewModel.quickPose.stop()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
