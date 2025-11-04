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
    @Published var setsInput: String = ""
    @Published var durationInput: String = ""
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
    
    func createExercise(
        from movement: Movement,
        setsString: String,
        repOrTimeString: String,
        currentExercises: [Exercise]
    ) -> Exercise? {
        
        guard !setsString.isEmpty,
              !repOrTimeString.isEmpty,
              let sets = Int(setsString),
              let repOrTime = Int(repOrTimeString)
        else {
            self.isError = true
            self.errorMessage = "Input tidak valid. Harap masukkan angka."
            return nil
        }
        
        
        guard sets > 0, repOrTime > 0 else {
            self.isError = true
            self.errorMessage = "Input harus lebih besar dari 0."
            return nil
        }
        
        let newId = (currentExercises.map { $0.id }.max() ?? 0) + 1
        let newExercise = Exercise(
            id: newId, // Use the new incremental ID
            name: movement.name,
            type: movement.type,
            image: movement.image,
            muscle: movement.muscle,
            description: movement.description,
            set: sets,
            repOrTime: repOrTime
        )
        
        self.isError = false
        self.errorMessage = ""
        return newExercise
    }
    
    
    
    func addExerciseToPatient(currentExercises: [Exercise]) -> Exercise? {
        guard let currentExercise = self.exercise else {
            self.isError = true
            self.errorMessage = "Tidak ada detail gerakan yang dipilih."
            return nil
        }
        
        guard let sets = Int(setsInput),
              let repOrTime = Int(durationInput),
              sets > 0,
              repOrTime > 0
        else {
            self.isError = true
            self.errorMessage = "Input tidak valid. Harap masukkan angka positif."
            return nil
        }
        
        let newId = (currentExercises.map { $0.id }.max() ?? 0) + 1
        
        let newExercise = Exercise(
            id: newId,
            name: currentExercise.name,
            type: currentExercise.type,
            image: "placeholder_image_url_from_video_or_detail",
            muscle: currentExercise.muscle,
            description: currentExercise.description,
            set: sets,
            repOrTime: repOrTime
        )
        
        
        print("Created exercise (from detail stub): \(newExercise.name)")
        return newExercise
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
}
