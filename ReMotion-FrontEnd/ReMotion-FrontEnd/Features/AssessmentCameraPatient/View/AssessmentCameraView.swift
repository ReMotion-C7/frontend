//
//  AssessmentCameraView.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 30/10/25.
//

import SwiftUI
import QuickPoseCore
import QuickPoseSwiftUI

struct PatientAssessmentCamera: View {
    
    @StateObject var viewModel = AssessmentCameraViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            QuickPoseCameraView(useFrontCamera: viewModel.useFrontCamera, delegate: viewModel.quickPose)
            QuickPoseOverlayView(overlayImage: $viewModel.overlayImage)
            
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
            
            if !viewModel.showModal && viewModel.startCountdown && viewModel.beginCountdown {
                Text("\(viewModel.displayedCountdown)")
            }
            
            if viewModel.displayResultModal && viewModel.imageResult != nil {
                VStack {
                    Text("Hasil Penilaian")
                        .font(Font.largeTitle.bold())
                    Image(uiImage: viewModel.imageResult!)
                    Text("Ruang Lingkup Gerak Sendi Lutut: \(viewModel.angle)°.")
                    NavigationLink(destination: EvaluasiGerakanPage()) {
                        Text("Selesai")
                            .background(Color.black)
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
            }
        }
        .onAppear(perform: viewModel.quickPoseSetup)
        .onDisappear {
            viewModel.quickPose.stop()
        }
        .onChange(of: viewModel.showModal) { show in
            if !show {
                print("CHECKING COUNTDOWN")
                viewModel.checkCountdown()
            } else {
                viewModel.resetReadyCountdown()
            }
        }
    }
}
