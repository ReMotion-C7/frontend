//
//  DashboardCardSmall.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardCardSmall: View {
    let movement: Movement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(maxWidth: 244, maxHeight: 160)
                .overlay(
                    AsyncImage(url: URL(string: movement.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure(_):
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.3))
                        @unknown default:
                            EmptyView()
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 6) {
                // Name
                HStack {
                    Text(movement.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
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
                
                Divider()
                
                HStack{
                    // Type
                    Text(movement.type)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .opacity(0.6)
                        )
                    
                    // Category
                    Text(movement.category)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .opacity(0.6)
                        )
                }
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
