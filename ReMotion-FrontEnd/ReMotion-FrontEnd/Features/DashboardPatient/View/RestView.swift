//
//  RestView.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import SwiftUI
import Combine

struct RestView: View {
    let geometry: GeometryProxy
    let duration: TimeInterval
    let nextExercise: NextExerciseInfo
    
    // Callbacks to the ViewModel
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    // Timer specific state
    @State private var timeRemaining: TimeInterval
    // This creates a publisher that fires every second
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // We need to initialize the state from the passed-in duration
    init(geometry: GeometryProxy, duration: TimeInterval, nextExercise: NextExerciseInfo, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self.geometry = geometry
        self.duration = duration
        self.nextExercise = nextExercise
        self.onNext = onNext
        self.onPrevious = onPrevious
        // Initialize the state variable
        _timeRemaining = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            // Title
            Text("Istirahat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Timer Display
            Text(formatTime(timeRemaining))
                .font(.system(size: 60, weight: .bold))
                .monospacedDigit()
            
            // Add Time Button
            Button(action: {
                timeRemaining += 20
            }) {
                Label("20 detik", systemImage: "plus")
            }
            .buttonStyle(.bordered)
            .tint(.black)
            
            // Next Exercise Info (This would be an overlay on the video)
            // For now we put it here
            VStack(alignment: .leading) {
                Text("Gerakan selanjutnya...")
                    .font(.title3)
                    .foregroundColor(.gray)
                Text(nextExercise.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(nextExercise.setInfo)
                    .font(.body)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // --- Action Buttons ---
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Label("Lanjutkan", systemImage: "arrow.right")
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
        .frame(width: geometry.size.width * 0.4)
        .background(Color.white)
        .onReceive(timer) { _ in
            // This code runs every second
            guard timeRemaining > 0 else {
                // Timer finished, automatically go to next phase
                timer.upstream.connect().cancel() // Stop the timer
                onNext()
                return
            }
            timeRemaining -= 1
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
