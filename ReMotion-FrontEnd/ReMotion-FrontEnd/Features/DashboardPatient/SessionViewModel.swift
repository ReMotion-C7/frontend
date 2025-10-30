//
//  SessionViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 30/10/25.
//

import Combine
import Foundation
import Alamofire

class SessionViewModel: ObservableObject {
    
    @Published var readSessionResponses: ReadSessionsResponse?
    @Published var isLoading: Bool = false
    @Published var sessions: [Session] = []
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    
    func readSessions(patientId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }

        do {
            let response: ReadSessionsResponse = try await APIService.shared.requestAPI(
                "patients/\(patientId)/sessions",
                method: .get,
                responseType: ReadSessionsResponse.self
            )
            self.readSessionResponses = response
            if let data = readSessionResponses?.data {
                self.errorMessage = ""
                self.isError = false
                self.sessions = data
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data detail pasien!"
        }
    }
}
