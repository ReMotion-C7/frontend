//
//  PatientProgressViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 17/11/25.
//

import Foundation
import Combine
import Alamofire

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
        
        let dateDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let endpoint = "patients/\(patientId)/progresses"
        
        do {
            let apiResponse = try await APIService.shared.requestAPI(
                endpoint,
                method: .get,
                decoder: dateDecoder,
                responseType: ProgressApiResponse.self
            )
            
            self.sessionDates = Set(apiResponse.data.map { $0.date })
            
        } catch {
            print("Error fetching progress: \(error.localizedDescription)")
            self.errorMessage = "Gagal memuat data progress. Silakan coba lagi."
        }
        
        isLoading = false
    }
}
