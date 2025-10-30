//
//  ExerciseSessionCard.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI

struct ExerciseSessionCard: View {
    let exercise: Session
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                // Image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 240, height: 120)
                    .overlay(
                        AsyncImage(url: URL(string: exercise.image)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .clipped() // potong bagian yang keluar frame
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure(_):
                                Image(systemName: "photo") // fallback
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.3))
                            @unknown default:
                                EmptyView()
                            }
                        }
                    )
                
                VStack(alignment: .leading, spacing: 10) {
                    // Name
                    Text(exercise.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    // Muscle
                    Text(exercise.muscle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.black)
                        .cornerRadius(12)
                    
                    HStack(spacing: 16) {
                        // Sets
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text("\(exercise.set)x set")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        // Type
                        HStack(spacing: 4) {
                            Image(systemName: exercise.type.lowercased() == "waktu"
                                  ? "clock"
                                  : "arrow.counterclockwise")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            
                            Text(exercise.type.lowercased() == "waktu"
                                 ? "\(exercise.repOrTime) detik"
                                 : "\(exercise.repOrTime)x repetisi")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(16)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 24)
                .font(.system(size: 16, weight: .semibold))
        }
        .frame(width: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.01), radius: 8, x: 0, y: 2)
    }
}

//#Preview {
//    ExerciseSessionCard(
//        exercise: samplePatients[0].exercises[0]
//    )
//}
