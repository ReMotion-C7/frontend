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
        ScrollView {
            VStack(spacing: 16) {
                Text("Penting! Harap dibaca hingga selesai.")
                    .font(.system(size: 17.2, weight: .semibold))
                    .foregroundColor(.red)
                
                Text("DISCLAIMER!")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.red)
                
                VStack(spacing: 12) {
                    Text("Sesi latihan ini akan menampilkan skor gerakan Anda secara langsung.")
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                            .frame(height: 100)
                        
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 40))
                            .foregroundColor(Color(UIColor.systemGray3))
                        
                        Text("Gambar Fitur Skor AI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .offset(y: 35)
                    }
                }
                .padding(.horizontal, 20)
                
                Text("""
                Fitur ini menggunakan AI untuk memberikan skor **(0-100)** berdasarkan kesesuaian gerakan Anda dengan video tutorial. **Skor 100 berarti gerakan sempurna.**
                
                Namun, kami memahami bahwa setiap pasien, terutama pada fase awal pemulihan, memiliki kekuatan dan batasan yang berbeda.
                
                **Jangan jadikan skor ini sebagai acuan utama.** Lakukan setiap gerakan secara perlahan dan **sesuai dengan kemampuan Anda saat ini**. Fokus utama Anda adalah pemulihan yang aman.
                """)
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tips Pakaian untuk Hasil Terbaik")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Untuk memaksimalkan fitur deteksi gerak AI, gunakan pakaian yang pas di badan agar sendi utama Anda (bahu, siku, lutut) terlihat jelas.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    Text("Pakaian yang tidak disarankan:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                            .frame(height: 150)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red.opacity(0.6))
                        
                        Text("Contoh: Baju longgar / oversized, jaket")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .offset(y: 60)
                    }
                    
                    Text("Pakaian yang disarankan:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                            .frame(height: 150)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green.opacity(0.7))
                        
                        Text("Contoh: Kaos & celana yang pas di badan")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .offset(y: 60)
                    }
                }
                .padding(.horizontal, 20)
                                
                Spacer(minLength: 8)
                
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showModal = false
                            navigateToExercisePage = true
                        }
                    }) {
                        Text("Saya Mengerti, Mulai Latihan")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(18)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showModal = false
                        }
                    }) {
                        Text("Kembali")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                            .cornerRadius(18)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 25)
        .frame(width: 360, height: 660)
        .background(Color.white)
        .cornerRadius(24)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        SafetyModal(
            showModal: .constant(true),
            navigateToExercisePage: .constant(false)
        )
    }
}
