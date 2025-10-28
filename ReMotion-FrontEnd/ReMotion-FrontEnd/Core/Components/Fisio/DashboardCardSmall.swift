//
//  DashboardCardSmall.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardCardSmall: View {
    let movement: Movement
    
    private var labelIcon: String {
        switch movement.type.lowercased() {
        case "waktu":
            return "timer"
        case "repetisi":
            return "arrow.counterclockwise"
        default:
            return "clock"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 244, height: 160)
                .overlay(
                    Image(systemName: movement.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 6) {
                // Name
                HStack {
                    Text(movement.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: labelIcon)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(movement.type)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(3)
                }
                
                // Muscle
                Text(movement.muscle)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black)
                    .clipShape(Capsule())
                
                // Description
                Text(movement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .frame(width: 244, height: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 5)
        )
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
            ForEach(sampleMovements) { movement in
                DashboardCardSmall(movement: movement)
            }
        }
        .padding()
    }
}
