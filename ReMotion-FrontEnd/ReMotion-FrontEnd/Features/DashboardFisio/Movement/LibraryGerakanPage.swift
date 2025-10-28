//
//  LibraryGerakanPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import SwiftUI

struct LibraryGerakanPage: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                // Hitung jumlah kolom berdasarkan lebar layar
                let availableWidth = geometry.size.width // padding
                let itemWidth: CGFloat = 244
                let spacing: CGFloat = 30
                let columnsCount = max(Int(availableWidth / (itemWidth + spacing)), 1)
                
                // Buat grid layout dinamis
                let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
                
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(sampleMovements) { move in
                        NavigationLink(destination: DetailMovementPage(movement: move)) {
                            DashboardCardSmall(
                                imageName: move.imageName,
                                title: move.title,
                                category: move.category,
                                label: move.label,
                                description: move.description
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    LibraryGerakanPage()
}
