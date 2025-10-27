//
//  AddMovementPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import SwiftUI

struct AddMovementPage: View {
    @State private var videoUploaded = false
    @State private var movementTitle = ""
    @State private var trainingType = "Repetisi"
    @State private var targetMuscle = ""
    @State private var description = ""
    
    let trainingOptions = ["Repetisi", "Durasi"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Upload video section
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 220)
                
                if videoUploaded {
                    Image(systemName: "video.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                } else {
                    VStack {
                        Image(systemName: "video.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Unggah Video")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Movement Title
            VStack(alignment: .leading, spacing: 6) {
                Text("Masukkan Judul Gerakan")
                    .font(.subheadline)
                    .fontWeight(.medium)
                TextField("cth. Latihan lutut", text: $movementTitle)
                    .padding()
                    .border(Color.gray.opacity(0.1), width: 1)
                    .cornerRadius(8)
            }
            
            // Exercise Type
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pilih Jenis Latihan")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Menu {
                        ForEach(trainingOptions, id: \.self) { option in
                            Button(option) { trainingType = option }
                        }
                    } label: {
                        HStack {
                            Text(trainingType)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .foregroundColor(.gray)
                        .border(Color.gray.opacity(0.1), width: 1)
                        .cornerRadius(8)
                    }
                }
                
                // Target Muscle
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pilih Target Otot")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("cth. Otot Paha Depan", text: $targetMuscle)
                        .padding()
                        .border(Color.gray.opacity(0.1), width: 1)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: 700)
            
            // Description
            VStack(alignment: .leading, spacing: 6) {
                Text("Masukkan Deskripsi Gerakan")
                    .font(.subheadline)
                    .fontWeight(.medium)
                TextField("Deskripsi", text: $description)
                    .padding(8)
                    .frame(height: 100)
                    .cornerRadius(8)
                    .border(Color.gray.opacity(0.1), width: 1)
            }
            
            // Add Button
            Button(action: {
            }) {
                Text("Unggah Gerakan")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .padding(20)
    }
}

#Preview {
    AddMovementPage()
}
