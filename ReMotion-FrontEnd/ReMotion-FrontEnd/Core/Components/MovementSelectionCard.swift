//
//  MovementSelectionCard.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

enum ImageSource {
    case sfSymbol(String)
    case url(String)
}

struct MovementSelectionCard: View {
    let name: String
    let type: String
    let muscle: String
    let imageSource: ImageSource
    
    init(name: String, type: String, muscle: String, imageSource: ImageSource) {
        self.name = name
        self.type = type
        self.muscle = muscle
        self.imageSource = imageSource
    }
    
    init(movement: Movement) {
        self.name = movement.name
        self.type = movement.type
        self.muscle = movement.muscle
        self.imageSource = .sfSymbol(movement.image)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            contentSection
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 130)
            
            switch imageSource {
            case .sfSymbol(let symbolName):
                Image(systemName: symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .foregroundColor(.gray.opacity(0.3))
                
            case .url(let urlString):
                AsyncImage(url: URL(string: urlString)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 130)
                    case .failure(_):
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(height: 130)
                    default:
                        ProgressView()
                            .frame(height: 130)
                    }
                }
            }
        }
        .frame(height: 130)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 36, alignment: .top)
            
            HStack(spacing: 8) {
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: type == "Waktu" ? "clock.fill" : "repeat")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(type)
                        .font(.system(size: 12,  weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.4))
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background( Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .cornerRadius(4))
        
                
                Text(muscle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                    )
                    .lineLimit(1)
            }
            
        }
        .padding(16)
    }
}
