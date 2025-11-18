//
//  PatientExerciseCard.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 26/10/25.
//

import SwiftUI

struct PatientExerciseCard: View {
    let exercise: Exercise
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: exercise.image)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 320, height: 180)
                            .overlay(
                                ProgressView()
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 320, height: 180)
                            .clipped()
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 320, height: 180)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.3))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 320, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Menu {
                    Button(action: { onEdit?() }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { onDelete?() }) {
                        Label("Hapus", systemImage: "trash")
                    }
                } label: {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(90))
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(12)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 8) {
                    Text(exercise.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: getExerciseIcon())
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                        Text(getExerciseTypeText())
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                    )
                }
                
                Text(exercise.muscle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        Text("\(exercise.set)x Set")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: getExerciseIcon())
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        Text(getExerciseValueText())
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Text(exercise.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.8))
                    .lineLimit(3)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
        }
        .frame(width: 320, height: 340)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
 
    private func getExerciseTypeText() -> String {
        let type = exercise.type.lowercased()
        if type.contains("waktu") || type.contains("time") {
            return "Waktu"
        } else if type.contains("repetisi") || type.contains("rep") {
            return "Repetisi"
        }
        return exercise.type
    }
    
    private func getExerciseIcon() -> String {
        let type = exercise.type.lowercased()
        if type.contains("waktu") || type.contains("time") {
            return "clock"
        } else {
            return "repeat"
        }
    }
    
    private func getExerciseValueText() -> String {
        let type = exercise.type.lowercased()
        if type.contains("waktu") || type.contains("time") {
            return "\(exercise.repOrTime) detik"
        } else {
            return "\(exercise.repOrTime)x Rep"
        }
    }
}

