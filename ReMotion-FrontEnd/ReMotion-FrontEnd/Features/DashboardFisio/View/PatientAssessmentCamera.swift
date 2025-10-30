//
//  PatientAssessmentCamera.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 28/10/25.
//

import SwiftUI
import QuickPoseCore
import QuickPoseSwiftUI

struct PatientAssessmentCamera: View {
    let quickPose = QuickPose(sdkKey: "01K8MHW0TEMZC3V03HWGB7D1MQ")
    let edgeInsets = QuickPose.RelativeCameraEdgeInsets(top: 0.03, left: 0.13, bottom: 0.03, right: 0.13)
    
    @State private var overlayImage: UIImage?
    @State private var useFrontCamera: Bool = true
    @State private var feedbackText: String? = nil
    @State private var showModal: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            QuickPoseCameraView(useFrontCamera: useFrontCamera, delegate: quickPose)
            QuickPoseOverlayView(overlayImage: $overlayImage)
            
            if showModal {
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
        .onAppear(perform: quickPoseSetup)
        .onDisappear {
            quickPose.stop()
        }
    }
    
    private func quickPoseSetup() {
        let basicStyle = QuickPose.Style(
            relativeFontSize: 0.5,
            relativeArcSize: 0.2,
            relativeLineWidth: 0.5,
            conditionalColors: [QuickPose.Style.ConditionalColor(min: nil, max: 150, color: UIColor.green)]
        )
                
        quickPose.start(
            features: [
                .inside(edgeInsets),
                .rangeOfMotion(.knee(side: .left, clockwiseDirection: false), style: basicStyle),
                .rangeOfMotion(.knee(side: .right, clockwiseDirection: false), style: basicStyle),
                .overlay(.upperBody)
            ]
        ) { status, outputImage, measurements, feedback, body in
            overlayImage = outputImage
            
            switch status {
            case .success:
                
//                print(feedback.values.first?.isRequired)
                
                if feedback.values.first != nil {
                    print("OKE BANG")
                    showModal = true
                } else {
                    showModal = false
                }
                
//                if let stringValue = measurements.values.first?.stringValue,
//                   let intValue = Int(stringValue),
//                   intValue >= 60 {
//                    print("OKE BANG")
//                    showModal.toggle()
//                }
            case .noPersonFound:
                print("GAADA ORANG BANGG")
            case .sdkValidationError:
                print("APALAH INI")
            }
        }
    }
}

#Preview {
    PatientAssessmentCamera()
}
