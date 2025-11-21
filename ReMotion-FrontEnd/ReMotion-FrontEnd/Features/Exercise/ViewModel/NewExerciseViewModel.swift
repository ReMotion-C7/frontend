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
import AVFoundation
import Alamofire

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
    
    @Published var workoutPhases: [NewWorkoutPhase] = []
    @Published var currentPhaseIndex: Int = 0
    @Published var isSessionFinished: Bool = false
    
    @Published var leftKneeScore:Double = 0.0
    @Published var rightKneeScore:Double = 0.0
    
    
    let idealKneeAngle = 90.0
    
    @Published var remainingTime: Int = 0
    private var timer: Timer?
    
    @Published var jointsToTrack: [JointConfig] = []
    @Published var jointScores: [String: Double] = [:]
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("❌ Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("❌ Could not play sound: \(error)")
        }
    }
    
    
    func quickPoseSetup() {
        
        guard let currentPhase = newCurrentPhase else { return }
        
        switch currentPhase {
        case .exercise(let details, _):
            self.jointsToTrack = details.jointsToTrack
            
            jointScores.removeAll()
            
            //                quickPose.stop()
            //                quickPoseSetup()
            
        case .rest:
            print("Rest phase - keeping previous joints")
            break
        }
        
        
        let basicStyle = QuickPose.Style(
            relativeFontSize: 0.5,
            relativeArcSize: 0.2,
            relativeLineWidth: 0.5,
            conditionalColors: [QuickPose.Style.ConditionalColor(min: nil, max: 150, color: UIColor.green)]
        )
        
        var features: [QuickPose.Feature] = [
            .inside(edgeInsets),
            .overlay(.none)
        ]
        
        for joint in jointsToTrack {
            let feature = createRangeOfMotionFeature(for: joint, style: basicStyle)
            features.append(feature)
        }
        
        quickPose.start(
            //            features: [
            //                .inside(edgeInsets),
            //                .rangeOfMotion(.knee(side: .left, clockwiseDirection: true), style: basicStyle),
            //                .rangeOfMotion(.knee(side: .right, clockwiseDirection: true), style: basicStyle),
            //                .overlay(.none)
            //            ]
            features: features
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
                    
                    self.processMeasurements(measurements)
                    
                    //                    for (feature, result) in measurements {
                    //                        switch feature {
                    //                        case .rangeOfMotion(let rom, _):
                    //                            switch rom {
                    //                            case .knee(side: .left, _):
                    //                                print("Left knee angle: \(result.stringValue)")
                    //                                self.leftKneeScore = self.countIdealScore(for: result.value, ideal: 90, tolerance: 90)
                    //                            case .knee(side: .right, _):
                    //                                print("Right knee angle: \(result.stringValue)")
                    //                                self.rightKneeScore = self.countIdealScore(for: result.value, ideal: 90, tolerance: 90)
                    //                            default:
                    //                                break
                    //                            }
                    //
                    //                        case .inside:
                    //                            print("Inside score: \(result.stringValue)")
                    //
                    //                        default:
                    //                            break
                    //                        }
                    //                    }
                    
                case .noPersonFound:
                    print("GAADA ORANG BANGG")
                case .sdkValidationError:
                    print("APALAH INI")
                }
            }
        }
    }
    
    private func createRangeOfMotionFeature(for joint: JointConfig, style: QuickPose.Style) -> QuickPose.Feature {
        let side = joint.side  // Use the converted side
        
        switch joint.type {
        case .knee:
            return .rangeOfMotion(.knee(side: side, clockwiseDirection: true), style: style)
        case .hip:
            return .rangeOfMotion(.hip(side: side, clockwiseDirection: true), style: style)
        case .elbow:
            return .rangeOfMotion(.elbow(side: side, clockwiseDirection: true), style: style)
        case .shoulder:
            return .rangeOfMotion(.shoulder(side: side, clockwiseDirection: true), style: style)
        case .ankle:
            return .rangeOfMotion(.ankle(side: side, clockwiseDirection: true), style: style)
        }
    }
    
    private func processMeasurements(_ measurements: [QuickPose.Feature: QuickPose.FeatureResult]) {
        for (feature, result) in measurements {
            switch feature {
            case .rangeOfMotion(let rom, _):
                let key = getROMKey(rom)
                let score = countIdealScore(for: result.value, ideal: 90, tolerance: 90)
                
                jointScores[key] = score
                print("\(key): \(result.stringValue) - Score: \(score)")
                
            default:
                break
            }
        }
    }
    
    var averageJointScore: Double {
        guard !jointScores.isEmpty else { return 0.0 }
        let sum = jointScores.values.reduce(0, +)
        return sum / Double(jointScores.count)
    }
    
    // Get a unique key for each ROM measurement
    private func getROMKey(_ rom: QuickPose.RangeOfMotion) -> String {
        switch rom {
        case .knee(let side, _):
            return "knee_\(side == .left ? "left" : "right")"
        case .hip(let side, _):
            return "hip_\(side == .left ? "left" : "right")"
        case .elbow(let side, _):
            return "elbow_\(side == .left ? "left" : "right")"
        case .shoulder(let side, _):
            return "shoulder_\(side == .left ? "left" : "right")"
        case .ankle(let side, _):
            return "ankle_\(side == .left ? "left" : "right")"
        default:
            return "unknown"
        }
    }
    
    private func countIdealScore(for measured: Double, ideal: Double, tolerance: Double) -> Double {
        let diff = abs(measured - ideal)
        if diff >= tolerance { return 0.0 }
        return 1.0 - (diff / tolerance)
    }
    
    var newCurrentPhase: NewWorkoutPhase? {
        guard currentPhaseIndex < workoutPhases.count else { return nil }
        return workoutPhases[currentPhaseIndex]
    }
    
    func newStartSession(with exercises: [NewExercises]) {
        print("INI MASUK NE START SESSION")
        self.workoutPhases = newGenerateWorkoutPhases(from: exercises)
        self.currentPhaseIndex = 0
        self.isSessionFinished = false
    }
    
    func newGoToNextPhase() {
        if currentPhaseIndex < workoutPhases.count - 1 {
            currentPhaseIndex += 1
        } else {
            // This was the last phase, so finish the session
            isSessionFinished = true
        }
    }
    
//    func newGoToPreviousPhase() {
//        if currentPhaseIndex > 0 {
//            currentPhaseIndex -= 1
//        }
//    }
    
    private func newGenerateWorkoutPhases(from exercises: [NewExercises]) -> [NewWorkoutPhase] {
        print("INI NGE GENERATE WORKOUT PHASE BRO")
        var phases: [NewWorkoutPhase] = []
        let defaultRestDuration: TimeInterval = 30.0
        
        for (exerciseIndex, exercise) in exercises.enumerated() {
            for currentSet in 1...exercise.set {
                // 1. Add the EXERCISE phase
                phases.append(.exercise(details: exercise, currentSet: currentSet))
                
                // 2. Add a REST phase if it's not the absolute final set
                let isLastExercise = (exerciseIndex == exercises.count - 1)
                let isLastSetOfExercise = (currentSet == exercise.set)
                
                if !(isLastExercise && isLastSetOfExercise) {
                    let nextExerciseInfo: NewNextExerciseInfo
                    
                    if !isLastSetOfExercise {
                        // Next is another set of the SAME exercise
                        let setInfo = "\(exercise.repOrTime) \(exercise.method == "Waktu" ? "Detik" : "Rep")"
                        nextExerciseInfo = NewNextExerciseInfo(name: exercise.name, video: exercise.video, muscle: exercise.muscle, setInfo: setInfo)
                    } else {
                        // Next is the FIRST set of the NEXT exercise
                        let nextExercise = exercises[exerciseIndex + 1]
                        let setInfo = "\(nextExercise.set)x \(nextExercise.repOrTime) \(nextExercise.method == "Waktu" ? "Detik" : "Rep")"
                        nextExerciseInfo = NewNextExerciseInfo(name: nextExercise.name, video: nextExercise.video, muscle: nextExercise.muscle, setInfo: setInfo)
                    }
                    
                    phases.append(.rest(duration: defaultRestDuration, nextExercise: nextExerciseInfo))
                }
            }
        }
        return phases
    }
    
    func startCountdown(from remainingTime: Int) {
        // Stop existing timer if running
        timer?.invalidate()
        self.remainingTime = remainingTime
        
        // Create a new timer that ticks every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate()
                self.newGoToNextPhase()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    var formattedRemainingTime: String {
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
    
    //    func checkCountdown() {
    //        Task {
    //            try? await Task.sleep(for: .seconds(3))
    //            if !self.showModal {
    //                self.startCountdown = true
    //                print("UDAH BANG 3 DETIK")
    //            }
    //        }
    //    }
    //
    //    func resetReadyCountdown() {
    //        self.startCountdown = false
    //    }
    //
    //    func startBeginCountdown() {
    //        if !self.showModal && self.startCountdown {
    //            self.beginCountdown = true
    //            timer?.invalidate()
    //
    //            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
    //                guard let self = self else { return }
    //
    //                if self.displayedCountdown > 0 {
    //                    self.displayedCountdown -= 1
    //                } else {
    //                    self.timer?.invalidate()
    //                    print("UDAH BANG TIMER NYA 5 DETIK")
    //
    //                    self.displayResultModal = true
    //                    if let lastFrame = self.lastImage, let overlay = self.overlayImage,
    //                       let combined = self.combineImages(background: lastFrame, overlay: overlay) {
    //                        self.imageResult = combined
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    private func combineImages(background: UIImage, overlay: UIImage) -> UIImage? {
    //        UIGraphicsBeginImageContextWithOptions(background.size, false, 0.0)
    //        background.draw(in: CGRect(origin: .zero, size: background.size))
    //        overlay.draw(in: CGRect(origin: .zero, size: background.size), blendMode: .normal, alpha: 1.0)
    //        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        return combinedImage
    //    }
    
    
    func finishSession(patientId: Int) async {
        // 1. Prepare the date and decoder
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC for consistency
        
        let todayString = dateFormatter.string(from: today)
        
        let dateDecoder = JSONDecoder()
        dateDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            // 2. Fetch existing progress dates
            let endpoint = "patients/\(patientId)/progresses"
            let progressResponse = try await APIService.shared.requestAPI(
                endpoint,
                method: .get,
                decoder: dateDecoder,
                responseType: ProgressDateApiResponse.self
            )
            
            let existingDates = progressResponse.data.map { $0.date }
            
            // 3. Check if today's date already exists
            let hasExercisedToday = existingDates.contains { date in
                Calendar.current.isDate(date, inSameDayAs: today)
            }
            
            if hasExercisedToday {
                print("✅ Progress for today already recorded. Skipping.")
                // No need to do anything else, just proceed to dismiss the view.
            } else {
                // 4. If it doesn't exist, add the new progress
                print("📝 Recording progress for today: \(todayString)")
                let addEndpoint = "patients/\(patientId)/progresses/add"
                let parameters: [String: String] = ["date": todayString]
                
                let _: AddProgressResponse = try await APIService.shared.requestAPI(
                    addEndpoint,
                    method: .post,
                    parameters: parameters,
                    responseType: AddProgressResponse.self
                )
                print("✅ Successfully added progress for today.")
            }
            
        } catch {
            // If anything fails (fetching or adding), just print the error.
            // The user experience is to simply go back to the session page.
            print("❌ Failed to record progress: \(error.localizedDescription)")
        }
    }
    
    func newGoToPreviousPhase() {
        // Only go back if we are not at the very first phase
        if currentPhaseIndex > 0 {
            currentPhaseIndex -= 1
        }
    }

    func addRestTime(seconds: Int) {
        // Simply add the specified number of seconds to the current remaining time
        // This will work even if the timer is already running.
        if remainingTime > 0 {
            remainingTime += seconds
        }
    }
}
