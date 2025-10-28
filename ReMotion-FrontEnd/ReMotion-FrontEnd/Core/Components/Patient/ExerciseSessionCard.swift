//
//  ExerciseSessionCard.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI

struct ExerciseSessionCard: View {
    let movement: Movement
    let sets: String
    let duration: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 280, height: 160)
                .overlay(
                    Image(systemName: movement.image)
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.3))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movement.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(movement.muscle)
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
            }
            Spacer()
            
            Image("chevron.right")
                .foregroundColor(.gray)
        }
        .frame(width:. infinity)
    }
}

#Preview {
    ExerciseSessionCard(
        movement: sampleMovements[0],
        sets: "15x Set",
        duration: "10 detik"
    )
}
