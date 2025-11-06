//
//  NewExerciseViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 03/11/25.
//

import Foundation
import QuickPoseCore
import Combine
import SwiftUI

class NewExerciseViewModel: ObservableObject {
    @Published var quickPose = QuickPose(sdkKey: "01K8MHW0TEMZC3V03HWGB7D1MQ")
    @Published var edgeInsets = QuickPose.RelativeCameraEdgeInsets(top: 0.027, left: 0.24, bottom: 0.027, right: 0.24)
    
    @Published var overlayImage: UIImage?
    @Published var useFrontCamera: Bool = true
    @Published var feedbackText: String? = nil
    @Published var showModal: Bool = true
    @Published var startCountdown: Bool = false
    @Published var beginCountdown: Bool = false
    @Published var displayedCountdown: Int = 5
    @Published var displayResultModal: Bool = false
    @Published var lastImage: UIImage? = nil
    @Published var imageResult: UIImage? = nil
    @Published var angle: Int = 0
    @Published var poseScore: Int = 0
    @Published var showExitModal: Bool = false
    
    @Published var leftKneeScore:Double = 0.0
    @Published var rightKneeScore:Double = 0.0
    
    let idealKneeAngle = 90.0
    
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
                .rangeOfMotion(.knee(side: .left, clockwiseDirection: true), style: basicStyle),
                .rangeOfMotion(.knee(side: .right, clockwiseDirection: true), style: basicStyle),
                .overlay(.none)
            ]
        ) { status, outputImage, measurements, feedback, body in
            
            DispatchQueue.main.async {
                self.lastImage = outputImage
                self.overlayImage = outputImage
                
                switch status {
                case .success:
                    
                    if feedback.values.first != nil {
                        print("MEASUREMENTS VALUES")
                        print(measurements.values)
                        
                        self.showModal = true
                    } else {
                        self.showModal = false
                    }
                    
                    for (feature, result) in measurements {
                        switch feature {
                        case .rangeOfMotion(let rom, _):
                            switch rom {
                            case .knee(side: .left, _):
                                print("Left knee angle: \(result.stringValue)")
                                self.leftKneeScore = self.countIdealScore(for: result.value, ideal: 90, tolerance: 90)
                            case .knee(side: .right, _):
                                print("Right knee angle: \(result.stringValue)")
                                self.rightKneeScore = self.countIdealScore(for: result.value, ideal: 90, tolerance: 90)
                            default:
                                break
                            }
                            
//                            case .inside:
//                                print("Inside score: \(result.stringValue)")
                            
                        default:
                            break
                        }
                    }
                    
                case .noPersonFound:
                    print("GAADA ORANG BANGG")
                case .sdkValidationError:
                    print("APALAH INI")
                }
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
                    
                    self.displayResultModal = true
                    if let lastFrame = self.lastImage, let overlay = self.overlayImage,
                       let combined = self.combineImages(background: lastFrame, overlay: overlay) {
                        self.imageResult = combined
                    }
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
    
    private func countIdealScore(for measured: Double, ideal: Double, tolerance: Double) -> Double {
        let diff = abs(measured - ideal)
        if diff >= tolerance { return 0.0 }
        return 1.0 - (diff / tolerance)
    }
}
