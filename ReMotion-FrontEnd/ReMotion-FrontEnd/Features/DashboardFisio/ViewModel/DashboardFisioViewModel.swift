//
//  DashboardFisioViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import Combine
import Foundation
import Alamofire

@MainActor
class DashboardFisioViewModel: ObservableObject {
    
    @Published var readPatientResponse: ReadPatientResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var patients: [ReadPatientData] = []
    
    func readPatients(fisioId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadPatientResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients",
                method: .get,
                responseType: ReadPatientResponse.self
            )
            self.readPatientResponse = response
            if let data = readPatientResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.patients = data
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data pasien!"
        }
        
    }
}
