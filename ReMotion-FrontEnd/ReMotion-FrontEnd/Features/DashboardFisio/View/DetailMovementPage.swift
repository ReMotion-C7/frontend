//
//  DetailMovement.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 24/10/25.
//

import SwiftUI

struct DetailMovementPage: View {
    // This property holds the movement data passed from LibraryGerakanPage
    let movement: Movement
    
    // Computed property to get the correct icon based on the label
    private var labelIcon: String {
        switch movement.label.lowercased() {
        case "waktu":
            return "timer"
        case "repetisi":
            return "arrow.counterclockwise"
        default:
            return "clock" // A default icon
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // --- Video/Image Placeholder ---
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                    
                    Image(systemName: movement.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)

                    VStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Putar Video")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.black.opacity(0.3))
                    .cornerRadius(10)

                }
                .frame(height: 350)
                .cornerRadius(12)
                .padding(.bottom, 10)
                
                // --- Movement Title ---
                Text(movement.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // --- Tags (Label and Category) ---
                HStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: labelIcon)
                            .font(.callout)
                        Text(movement.label)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(8)
                    
                    Text(movement.category)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .font(.callout)
                
                // --- Description ---
                Text(movement.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(5)
                
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .navigationTitle("Detail Gerakan Latihan")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            // --- Default More Options Button with Menu ---
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    // --- Edit Button ---
                    Button(action: {
                        // TODO: Add action for editing the movement
                        print("Edit Gerakan tapped")
                    }) {
                        Label("Edit Gerakan", systemImage: "square.and.pencil")
                    }
                    
                    // --- Delete Button ---
                    Button(role: .destructive, action: {
                        // TODO: Add action for deleting the movement
                        print("Hapus Gerakan tapped")
                    }) {
                        Label("Hapus Gerakan", systemImage: "trash")
                    }
                } label: {
                    // This is the button that the user taps
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailMovementPage(movement: sampleMovements[1])
    }
}
