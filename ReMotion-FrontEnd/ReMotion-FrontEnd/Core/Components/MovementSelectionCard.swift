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
        HStack(spacing: 36) {
            imageSection
            contentSection
        }
        .frame(maxWidth: .infinity, minHeight: 110, maxHeight: 110)
        .background(Color.white)
        .shadow(color: .black.opacity(0.01), radius: 8, x: 0, y: 2)
    }
    
    @ViewBuilder
    private var imageSection: some View {
        ZStack {
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
                            .frame(height: 110)
                    case .failure(_):
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(height: 110)
                    default:
                        ProgressView()
                            .frame(height: 110)
                    }
                }
            }
        }
        .frame(width: 110, height: 110)
    }
    
    private var contentSection: some View {
        HStack(spacing: 12) {
            Text(name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .semibold))
        }
        .padding(16)
    }
}
