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
    let onNext: () -> Void
    let onPrevious: () -> Void
    @State private var timeRemaining: TimeInterval
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(geometry: GeometryProxy, duration: TimeInterval, nextExercise: NextExerciseInfo, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self.geometry = geometry
        self.duration = duration
        self.nextExercise = nextExercise
        self.onNext = onNext
        self.onPrevious = onPrevious
        _timeRemaining = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Istirahat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(formatTime(timeRemaining))
                .font(.system(size: 60, weight: .bold))
                .monospacedDigit()
            
            Button(action: {
                timeRemaining += 20
            }) {
                Label(" 20 detik", systemImage: "plus")
            }
            .buttonStyle(.bordered)
            .tint(.black)
            
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
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Label("Lanjutkan", systemImage: "arrow.right")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .foregroundColor(.white)
                .background(GradientPurple())
                .cornerRadius(10)
                
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
            guard timeRemaining > 0 else {
                timer.upstream.connect().cancel()
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
