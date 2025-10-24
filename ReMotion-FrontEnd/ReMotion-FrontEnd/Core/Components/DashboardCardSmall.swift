//
//  DashboardCardSmall.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardCardSmall: View {
    let imageName: String
    let title: String
    let category: String
    let label: String
    let description: String
    
    // IconLabel
    private var labelIcon: String {
        switch label.lowercased() {
        case "Waktu":
            return "timer"
        case "repetisi":
            return "arrow.counterclockwise"
        default:
            return "clock"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Gambar
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 244, height: 160)
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 6) {
                // Judul dan Label
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: labelIcon)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(label)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(3)
                }
                
                // Kategori
                Text(category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black)
                    .clipShape(Capsule())
                
                // Deskripsi
                Text(description)
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
    VStack(spacing: 20) {
        DashboardCardSmall(
            imageName: "photo",
            title: "Quadriceps set",
            category: "Otot Paha Depan",
            label: "Waktu",
            description: "Latihan ini dilakukan dengan posisi duduk atau berbaring, lalu mengencangkan otot paha depan seolah-olah mendorong bagian belakang lutut ke permukaan di bawahnya."
        )
    }
    .padding()
}
