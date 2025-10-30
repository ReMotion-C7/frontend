//
//  AssessmentCameraViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 30/10/25.
//

import Foundation
import QuickPoseCore
import Combine
import SwiftUI

class AssessmentCameraViewModel: ObservableObject {
    @Published var quickPose = QuickPose(sdkKey: "01K8MHW0TEMZC3V03HWGB7D1MQ")
    @Published var edgeInsets = QuickPose.RelativeCameraEdgeInsets(top: 0.03, left: 0.13, bottom: 0.03, right: 0.13)
    
    @Published var overlayImage: UIImage?
    @Published var useFrontCamera: Bool = true
    @Published var feedbackText: String? = nil
    @Published var showModal: Bool = true
    @Published var startCountdown: Bool = false
    @Published var beginCountdown: Bool = false
    
    @Published var displayedCountdown: Int = 5
    
    private var timer: Timer?
    
    func quickPoseSetup() {
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
            
            DispatchQueue.main.async {
                self.overlayImage = outputImage
                
                switch status {
                case .success:
                                        
                    if feedback.values.first != nil {
                        print("OKE BANG")
                        self.showModal = true
                    } else {
                        self.showModal = false
                    }
                case .noPersonFound:
                    print("GAADA ORANG BANGG")
                case .sdkValidationError:
                    print("APALAH INI")

            }
//            self.overlayImage = outputImage
//            
//            switch status {
//            case .success:
//                
////                print(feedback.values.first?.isRequired)
//                
//                if feedback.values.first != nil {
//                    print("OKE BANG")
//                    self.showModal = true
//                } else {
//                    self.showModal = false
//                }
//                
////                if let stringValue = measurements.values.first?.stringValue,
////                   let intValue = Int(stringValue),
////                   intValue >= 60 {
////                    print("OKE BANG")
////                    showModal.toggle()
////                }
//            case .noPersonFound:
//                print("GAADA ORANG BANGG")
//            case .sdkValidationError:
//                print("APALAH INI")
            }
        }
    }

    func checkCountdown() {
        Task {
            try? await Task.sleep(for: .seconds(3))
            if !self.showModal {
                self.startCountdown = true
                print("UDAH BANG 3 DETIK")
            }
        }
    }
    
    func resetReadyCountdown() {
        self.startCountdown = false
    }
    
    func startBeginCountdown() {
        if !self.showModal && self.startCountdown {
            self.beginCountdown = true
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.displayedCountdown > 0 {
                    self.displayedCountdown -= 1
                } else {
                    self.timer?.invalidate()
                    print("UDAH BANG TIMER NYA 5 DETIK")
                }
                
            }
        }
    }
    
    private func combineImages(background: UIImage, overlay: UIImage) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(background.size, false, 0.0)
            background.draw(in: CGRect(origin: .zero, size: background.size))
            overlay.draw(in: CGRect(origin: .zero, size: background.size), blendMode: .normal, alpha: 1.0)
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return combinedImage
        }


}
