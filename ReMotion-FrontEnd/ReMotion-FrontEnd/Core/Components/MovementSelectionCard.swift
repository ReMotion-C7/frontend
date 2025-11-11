//
//  MovementSelectionCard.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct MovementSelectionCard: View {
    let movement: Movement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            contentSection
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 130)
            
            Image(systemName: movement.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .foregroundColor(.gray.opacity(0.3))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(movement.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 36, alignment: .top)
            
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: movement.type == "Waktu" ? "clock.fill" : "repeat")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text(movement.type)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text(movement.muscle)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.black)
                )
                .lineLimit(1)
        }
        .padding(12)
    }
}

//#Preview {
//    HStack(spacing: 16) {
//        MovementSelectionCard(
//            movement: Movement(
//                id: 1,
//                name: "Quadriceps Set",
//                type: "Waktu",
//                description: "Latihan ini dilakukan dengan posisi duduk atau berbaring.",
//                muscle: "Otot Paha Depan",
//                image: "photo"
//            )
//        )
//        .frame(width: 170)
//        
//        MovementSelectionCard(
//            movement: Movement(
//                id: 2,
//                name: "Ankle Pump",
//                type: "Repetisi",
//                description: "Latihan fisik yang dipergunakan untuk melatih otot pada betis.",
//                muscle: "Otot Betis",
//                image: "photo"
//            )
//        )
//        .frame(width: 170)
//    }
//    .padding()
//    .background(Color.gray.opacity(0.1))
//}
