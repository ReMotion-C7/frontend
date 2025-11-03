//
//  DeleteModal.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 03/11/25.
//

import SwiftUI

struct DeleteModal: View {
    @Binding var showDeleteModal: Bool
    var exerciseName: String
    var onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text("Konfirmasi")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Body
            Text("Apakah anda yakin ingin menghapus gerakan \(exerciseName)? Aksi ini tidak dapat dibatalkan.")
                .font(.callout)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 8)
            
            // Button
            Button(action: {
                onConfirm()
            }) {
                Text("Lanjutkan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .cornerRadius(18)
            }
            
            Button(action: {
                withAnimation(.spring()) {
                    showDeleteModal = false
                }
            }) {
                Text("Batalkan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.gray)
                    .cornerRadius(18)
            }
        }
        .padding(30)
        .frame(width: 360, height: 240)
        .background(Color.white)
        .cornerRadius(24)
    }
}
