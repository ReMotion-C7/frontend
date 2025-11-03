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
        
        if name != nil {
            self.modalExercises = []
        }
        
        defer {
            isLoading = false
        }
        
        var endpoint = "fisio/exercises/modal"
        
        if let searchQuery = name, !searchQuery.isEmpty {
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
            
            if response.status == "success" {
                self.modalExercises = response.data ?? []
            } else {
                self.modalExercises = []
            }
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mencari gerakan. Silakan coba lagi."
            self.modalExercises = []
            print(error.localizedDescription)
        }
    }
}
