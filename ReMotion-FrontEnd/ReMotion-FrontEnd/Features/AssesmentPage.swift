//
//  AssesmentPage.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 28/10/25.
//

import SwiftUI

struct EvaluasiGerakanPage: View {
    @State private var isShowingInstructionModal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Text("Evaluasi Gerakan")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(
                action: {
                    isShowingInstructionModal = true
                }
            ) {
                HStack {
                    Text("Anterior Cruciate Ligament (ACL)")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.gray.opacity(0.7))
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.systemGray6))
        .sheet(isPresented: $isShowingInstructionModal) {
            AssesmentPageModal()
        }
    }
}

#Preview {
    NavigationStack {
        EvaluasiGerakanPage()
    }
}

