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
    @Published var readSessionExerciseDetailResponse: ReadSessionExerciseDetailResponse?
    @Published var isLoading: Bool = false
    @Published var sessions: [SessionV2] = []
    @Published var sessionExercise: SessionExerciseDetailV2? = nil
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
    
    func readSessionExerciseDetail(patientId: Int, exerciseId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadSessionExerciseDetailResponse = try await APIService.shared.requestAPI(
                "patients/\(patientId)/sessions/exercises/\(exerciseId)",
                method: .get,
                responseType: ReadSessionExerciseDetailResponse.self
            )
            self.readSessionExerciseDetailResponse = response
            if let data = readSessionExerciseDetailResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.sessionExercise = data
                print(data)
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data detail pasien!"
        }
    }
}
