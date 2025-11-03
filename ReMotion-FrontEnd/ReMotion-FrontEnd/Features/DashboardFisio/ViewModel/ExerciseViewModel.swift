//
//  ExerciseViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 30/10/25.
//

import Combine
import Foundation
import Alamofire

@MainActor
class ExerciseViewModel: ObservableObject {
    
    @Published var readExercisesResponse: ReadExercisesResponse?
    @Published var readExerciseDetailResponse: ReadExerciseDetailResponse?
    @Published var isLoading: Bool = false
    @Published var exercises: [Movement] = []
    @Published var exercise: MovementDetail?
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var modalExercises: [ModalExercise] = []
    
    func readExercises() async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadExercisesResponse = try await APIService.shared.requestAPI(
                "fisio/exercises",
                method: .get,
                responseType: ReadExercisesResponse.self
            )
            self.readExercisesResponse = response
            if let data = readExercisesResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.exercises = data
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data gerakan!"
        }
    }
    
    func readExerciseDetail(exerciseId: Int) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: ReadExerciseDetailResponse = try await APIService.shared.requestAPI(
                "fisio/exercises/\(exerciseId)",
                method: .get,
                responseType: ReadExerciseDetailResponse.self
            )
            self.readExerciseDetailResponse = response
            if let data = readExerciseDetailResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.exercise = data
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil detail gerakan!"
            print(error)
        }
    }
    
    func readModalExercises(name: String? = nil) async {
        isLoading = true
        isError = false
        errorMessage = ""
        
        // If it's a new search, clear previous results
        if name != nil {
            self.modalExercises = []
        }
        
        defer {
            isLoading = false
        }
        
        var endpoint = "fisio/exercises/modal"
        
        // If a search query is provided, append it to the endpoint
        if let searchQuery = name, !searchQuery.isEmpty {
            // URL encoding the search query to handle spaces and special characters
            if let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                endpoint += "?name=\(encodedQuery)"
            }
        }
        
        do {
            let response: ReadModalExercisesResponse = try await APIService.shared.requestAPI(
                endpoint,
                method: .get,
                responseType: ReadModalExercisesResponse.self
            )
            
            // Check for success status from backend
            if response.status == "success" {
                self.modalExercises = response.data ?? []
            } else {
                // Handle cases like "exercise not found"
                self.modalExercises = []
                // Optional: You can set an error message if you want to display it
                // self.errorMessage = response.message
            }
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mencari gerakan. Silakan coba lagi."
            self.modalExercises = [] // Clear data on error
            print(error.localizedDescription)
        }
    }
}
