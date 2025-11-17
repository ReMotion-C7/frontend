//
//  SafetyModal.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 30/10/25.
//

import SwiftUI


struct ModalStepInfo {
    let title: String
    let description: String
    let imageName: String
    let isSFSymbol: Bool
}

struct SafetyModal: View {
    @Binding var showModal: Bool
    @Binding var navigateToExercisePage: Bool
    
    @State private var currentStep = 0
    
    let steps: [ModalStepInfo] = [
        ModalStepInfo(
            title: "Sebelum Memulai Sesi Latihan 1/5",
            description: "Score bar bukan nilai mutlak. Angka yang muncul hanya menunjukkan seberapa mirip gerakan Anda dengan contoh video. Tidak perlu memaksakan hingga 100%, lakukan sebisa Anda. Tujuannya hanya sebagai panduan.",
            imageName: "ScoreBarIcon",
            isSFSymbol: false
        ),
        ModalStepInfo(
            title: "Sebelum Memulai Sesi Latihan 2/5",
            description: "Gunakan pakaian yang pas di tubuh. Hindari baju longgar atau oversize karena dapat mengganggu kamera dalam membaca pose tubuh Anda.",
            imageName: "tshirt.fill",
            isSFSymbol: true
        ),
        ModalStepInfo(
            title: "Sebelum Memulai Sesi Latihan 3/5",
            description: "Pastikan pencahayaan cukup dan kontras. Hindari latar belakang yang terlalu terang (backlight) agar tubuh Anda terlihat jelas di kamera.",
            imageName: "sun.max.fill",
            isSFSymbol: true
        ),
        ModalStepInfo(
            title: "Sebelum Memulai Sesi Latihan 4/5",
            description: "Seluruh tubuh harus terlihat di kamera. Dari kepala hingga ujung kaki harus masuk ke dalam frame. Jika sistem belum menampilkan tanda hijau, atur posisi kamera hingga tubuh terdeteksi sempurna.",
            imageName: "camera.fill",
            isSFSymbol: true
        ),
        ModalStepInfo(
            title: "Sebelum Memulai Sesi Latihan 5/5",
            description: "Ikuti arah dan bentuk gerakan seperti di video contoh. Jika contoh menghadap kiri, lakukan juga dengan arah yang sama agar sistem dapat menghitung gerakan Anda dengan benar.",
            imageName: "figure.cooldown",
            isSFSymbol: true
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text(steps[currentStep].title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack {
                Text(steps[currentStep].description)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Group {
                    if steps[currentStep].isSFSymbol {
                        Image(systemName: steps[currentStep].imageName)
                            .font(.system(size: 185, weight: .light))
                            .symbolRenderingMode(.monochrome)
                            .foregroundColor(.black)
                        
                    } else {
                        Image(steps[currentStep].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    }
                }
                .frame(height: 300)
                .padding(.vertical, 10)
            }
            
            VStack(spacing: 10) {
                Button(action: {
                    if currentStep < steps.count - 1 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        showModal = false
                        navigateToExercisePage = true
                    }
                }) {
                    Text(currentStep < steps.count - 1 ? "Selanjutnya" : "Mulai Sekarang")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                
                Button(action: {
                    if currentStep > 0 {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                }) {
                    Text("Kembali")
                        .fontWeight(.semibold)
                        .foregroundColor(currentStep == 0 ? .gray.opacity(0.5) : .primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(14)
                }
                .disabled(currentStep == 0)
                
                Button(action: {
                    withAnimation(.spring()) {
                        showModal = false
                    }
                }) {
                    Text("Keluar")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(14)
                }
            }
        }
        .padding(25)
        .frame(width: 700)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(24)
        .shadow(radius: 10)
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
