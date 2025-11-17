//
//  PatientProgressViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 17/11/25.
//

import Foundation
import Combine

@MainActor
class ProgressCalendarViewModel: ObservableObject {
    
    @Published var sessionDates: Set<Date> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func fetchProgress(patientId: Int) async {
        isLoading = true
        errorMessage = ""
        
        guard let url = URL(string: "https://your-base-url.com/v1/patients/\(patientId)/progresses") else {
            errorMessage = "URL tidak valid."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let apiResponse = try JSONDecoder().decode(ProgressApiResponse.self, from: data)
            
            let dates = apiResponse.data.compactMap { progress in
                dateFormatter.date(from: progress.date)
            }
            self.sessionDates = Set(dates)
            
        } catch {
            errorMessage = "Gagal memuat data progress: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
