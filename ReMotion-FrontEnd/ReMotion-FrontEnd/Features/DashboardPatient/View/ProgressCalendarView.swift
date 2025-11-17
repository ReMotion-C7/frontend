//
//  ProgressCalendar.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 17/11/25.
//

import SwiftUI

struct ProgressCalendarView: View {
    let patientId: Int
    @StateObject private var viewModel = ProgressCalendarViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text("Terjadi Kesalahan")
                        .font(.headline)
                    Text(viewModel.errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressCalendar(sessionDates: viewModel.sessionDates)
                    .padding(.vertical, 50)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            Task {
                await viewModel.fetchProgress(patientId: patientId)
            }
        }
    }
}

#Preview {
    ProgressCalendarView(patientId: 123)
}
