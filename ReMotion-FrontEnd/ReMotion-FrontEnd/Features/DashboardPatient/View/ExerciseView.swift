//
//  ExerciseView.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import SwiftUI
import Combine

struct ExerciseView: View {
    let geometry: GeometryProxy
    let exerciseDetails: Exercises
    let currentSet: Int
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    @State private var timeRemaining: TimeInterval
    @State private var timerSubscription: AnyCancellable?
    
    init(geometry: GeometryProxy, exerciseDetails: Exercises, currentSet: Int, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self.geometry = geometry
        self.exerciseDetails = exerciseDetails
        self.currentSet = currentSet
        self.onNext = onNext
        self.onPrevious = onPrevious
        _timeRemaining = State(initialValue: TimeInterval(exerciseDetails.repOrTime))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Spacer()
            
            // Exercise Title
            Text(exerciseDetails.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Muscle Chip
            Text(exerciseDetails.muscle)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
            
            // Set Counter
            Text("Set \(currentSet) / \(exerciseDetails.set)")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Reps or Time Display
            if exerciseDetails.type == "Waktu" {
                // Duration Type
                Text(formatTime(timeRemaining))
                    .font(.system(size: 60, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(timeRemaining > 0 ? .black : .gray)
            } else {
                // Repetition Type
                Text("\(exerciseDetails.repOrTime)x")
                    .font(.system(size: 60, weight: .bold))
            }
            
            Spacer()
            
            // --- Action Buttons ---
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Label("Selanjutnya", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                
                Button(action: onPrevious) {
                    Label("Sebelumnya", systemImage: "arrow.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            
            Spacer()
        }
        .padding(40)
        .frame(width: geometry.size.width * 0.4) // 40% of the screen
        .background(Color.white)
        .onAppear(perform: startTimerIfNeeded)
        .onDisappear(perform: stopTimer)
    }
    
    // Formats the remaining time into HH:MM:SS
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Checks if the exercise is duration-based and starts the timer.
    private func startTimerIfNeeded() {
        guard exerciseDetails.type == "Waktu" else { return }
        
        // Subscribe to a timer that publishes every second.
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Time is up. Stop the timer but DO NOTHING else.
                    stopTimer()
                }
            }
    }
    
    // Cancels the timer subscription to prevent it from running in the background.
    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
}
