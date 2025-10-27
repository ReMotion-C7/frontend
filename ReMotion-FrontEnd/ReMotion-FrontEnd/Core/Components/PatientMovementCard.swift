//
//  PatientMovementCard.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 26/10/25.
//

import SwiftUI

struct PatientMovementCard: View {
    let movement: Movement
    let sets: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 280, height: 160)
                    .overlay(
                        Image(systemName: movement.imageName)
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                    )
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(movement.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(movement.label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                }
                
                Text(movement.category)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .cornerRadius(12)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(sets)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(duration)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Text(movement.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(width: 280)
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    PatientMovementCard(
        movement: sampleMovements[0],
        sets: "15x Set",
        duration: "10 detik"
    )
}
