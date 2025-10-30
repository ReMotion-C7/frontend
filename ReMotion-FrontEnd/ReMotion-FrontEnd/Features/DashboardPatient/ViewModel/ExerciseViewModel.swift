//
//  ExerciseViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import Foundation
import Combine

class ExerciseViewModel: ObservableObject {
    
    // @Published properties will automatically update the UI when they change.
    @Published var workoutPhases: [WorkoutPhase] = []
    @Published var currentPhaseIndex: Int = 0
    @Published var isSessionFinished: Bool = false
    
    // A computed property to easily get the current phase
    var currentPhase: WorkoutPhase? {
        guard currentPhaseIndex < workoutPhases.count else { return nil }
        return workoutPhases[currentPhaseIndex]
    }
    
    // This is the main function to start a new session
    func startSession(with exercises: [Exercises]) {
        self.workoutPhases = generateWorkoutPhases(from: exercises)
        self.currentPhaseIndex = 0
        self.isSessionFinished = false
    }
    
    // --- User Actions ---
    
    func goToNextPhase() {
        if currentPhaseIndex < workoutPhases.count - 1 {
            currentPhaseIndex += 1
        } else {
            // This was the last phase, so finish the session
            isSessionFinished = true
        }
    }
    
    func goToPreviousPhase() {
        if currentPhaseIndex > 0 {
            currentPhaseIndex -= 1
        }
    }
    
    // --- Private Helper Function ---
    
    private func generateWorkoutPhases(from exercises: [Exercises]) -> [WorkoutPhase] {
        var phases: [WorkoutPhase] = []
        let defaultRestDuration: TimeInterval = 30.0

        for (exerciseIndex, exercise) in exercises.enumerated() {
            for currentSet in 1...exercise.set {
                // 1. Add the EXERCISE phase
                phases.append(.exercise(details: exercise, currentSet: currentSet))

                // 2. Add a REST phase if it's not the absolute final set
                let isLastExercise = (exerciseIndex == exercises.count - 1)
                let isLastSetOfExercise = (currentSet == exercise.set)

                if !(isLastExercise && isLastSetOfExercise) {
                    let nextExerciseInfo: NextExerciseInfo
                    
                    if !isLastSetOfExercise {
                        // Next is another set of the SAME exercise
                        let setInfo = "\(exercise.repOrTime) \(exercise.type == "Waktu" ? "Detik" : "Rep")"
                        nextExerciseInfo = NextExerciseInfo(name: exercise.name, video: exercise.video, muscle: exercise.muscle, setInfo: setInfo)
                    } else {
                        // Next is the FIRST set of the NEXT exercise
                        let nextExercise = exercises[exerciseIndex + 1]
                        let setInfo = "\(nextExercise.set)x \(nextExercise.repOrTime) \(nextExercise.type == "Waktu" ? "Detik" : "Rep")"
                        nextExerciseInfo = NextExerciseInfo(name: nextExercise.name, video: nextExercise.video, muscle: nextExercise.muscle, setInfo: setInfo)
                    }
                    
                    phases.append(.rest(duration: defaultRestDuration, nextExercise: nextExerciseInfo))
                }
            }
        }
        return phases
    }
}
