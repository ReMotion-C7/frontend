//
//  SafetyModal.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 30/10/25.
//

import SwiftUI

struct SafetyModal: View {
    @Binding var showModal: Bool
    @Binding var navigateToExercisePage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        showModal = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(8)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
            }
            
            // Title
            Text("Sebelum memulai latihan")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Body
            Text("""
            Pastikan Anda berada di tempat yang aman dan cukup luas untuk bergerak. \
            Gunakan pakaian yang nyaman, dan pastikan tubuh dalam kondisi siap tanpa rasa nyeri berlebih. \
            Ikuti instruksi latihan sesuai panduan fisioterapis Anda, dan hentikan sejenak jika muncul rasa tidak nyaman atau pusing.
            """)
            .font(.callout)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 8)
            
            // Button
            Button(action: {
                withAnimation(.easeInOut) {
                    showModal = false
                    navigateToExercisePage = true
                }
            }) {
                Text("Mulai")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(18)
            }
        }
        .padding(30)
        .frame(width: 360, height: 360)
        .background(Color.white)
        .cornerRadius(24)
//        .glassEffect(.identity, in:. rect(cornerRadius: 24))
    }
}

#Preview {
    SafetyModal(
        showModal: .constant(true),
        navigateToExercisePage: .constant(false)
    )
    .ignoresSafeArea()
}

