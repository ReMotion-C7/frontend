//
//  AssesmentPageModal.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 28/10/25.
//

import SwiftUI

struct AssesmentPageModal: View {
    @Environment(\.dismiss) var dismiss
    
    private let instructions = [
        "Pastikan seluruh tubuh mulai dari ujung kepala hingga ujung kaki terlihat di kamera",
        "Berdiri kurang lebih 3 meter dari kamera",
        "Pastikan area aman dan nyaman",
        "Hentikan latihan jika terasa nyeri",
        "Berdiri menghadap samping sesuai dengan instruksi",
        "Pastikan kaki yang sakit menghadap kamera",
        "Ikuti instruksi dengan benar"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Perhatikan beberapa hal berikut sebelum mulai")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(instructions, id: \.self) { instruction in
                                HStack(alignment: .top) {
                                    Text("•")
                                    Text(instruction)
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                            
                            Image(systemName: "figure.walk")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .foregroundColor(.secondary)
                            
                            Text("Placeholder Gambar Ilustrasi Gerakan")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .offset(y: 70)
                        }
                        .frame(height: 250)
                    }
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        print("Tombol Lanjutkan ditekan")
                        dismiss()
                    }) {
                        Text("Lanjutkan")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Batalakan")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color(.secondaryLabel))
                    .cornerRadius(14)
                }
            }
            .padding(24)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                }
            }
        }
    }
}

#Preview {
    
    AssesmentPageModal()
}
