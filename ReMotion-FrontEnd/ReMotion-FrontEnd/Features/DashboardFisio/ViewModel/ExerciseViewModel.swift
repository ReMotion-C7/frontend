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
    @Published var searchText: String = ""
    
    @Published var allModalExercises: [ModalExercise] = []
    
    func loadAllModalExercises() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response: ReadModalExercisesResponse = try await APIService.shared.requestAPI(
                "fisio/exercises/modal",
                method: .get,
                responseType: ReadModalExercisesResponse.self
            )
            
            if response.status == "success" {
                self.allModalExercises = response.data ?? []
                self.modalExercises = self.allModalExercises
            } else {
                self.allModalExercises = []
                self.modalExercises = []
            }
        } catch {
            self.allModalExercises = []
            self.modalExercises = []
            isError = true
            errorMessage = "Gagal memuat gerakan."
        }
    }

    
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
                
                await self.loadAllModalExercises()
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
    }
    
//    func readModalExercises(
//        name: String? = nil,
//        type: String? = nil,
//        category: String? = nil
//    ) async {
//        isLoading = true
//        isError = false
//        errorMessage = ""
//        
//        if name != nil {
//            self.modalExercises = []
//        }
//        
//        defer { isLoading = false }
//        
//        var endpoint = "fisio/exercises/modal"
//        var queryItems: [String] = []
//        
//        // Build query params
//        if let name, !name.isEmpty,
//           let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//            queryItems.append("name=\(encoded)")
//        }
//        
//        if let type, !type.isEmpty {
//            queryItems.append("type=\(type)")
//        }
//        
//        if let category, !category.isEmpty {
//            queryItems.append("category=\(category)")
//        }
//        
//        if !queryItems.isEmpty {
//            endpoint += "?" + queryItems.joined(separator: "&")
//        }
//        
//        do {
//            let response: ReadModalExercisesResponse = try await APIService.shared.requestAPI(
//                endpoint,
//                method: .get,
//                responseType: ReadModalExercisesResponse.self
//            )
//            
//            if response.status == "success" {
//                print("INI MODAL EXERCISE BANG \(response.data)")
//                self.modalExercises = response.data ?? []
//            } else {
//                self.modalExercises = []
//            }
//            
//        } catch {
//            self.isError = true
//            self.errorMessage = "Gagal mencari gerakan. Silakan coba lagi."
//            self.modalExercises = []
//            print(error.localizedDescription)
//        }
//    }

    func updateSearchText(_ text: String, type: String? = nil, category: String? = nil) {
        self.searchText = text
        filterModalExercises(name: text, type: type, category: category)
    }
    
    func filterModalExercises(
        name: String? = nil,
        type: String? = nil,
        category: String? = nil
    ) {
        var filtered = allModalExercises
        
        // Filter by name
        if let name, !name.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
        
        // Filter by type
        if let type, !type.isEmpty {
            filtered = filtered.filter { $0.type == type }
        }
        
        // Filter by category
        if let category, !category.isEmpty {
            filtered = filtered.filter { $0.category == category }
        }

        self.modalExercises = filtered
    }
    
    func deleteExercise(exerciseId: Int) async -> Bool {
        isLoading = true
        isError = false
        errorMessage = ""
        
        defer {
            isLoading = false
        }
        
        do {
            let response: DeleteExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/exercises/delete/\(exerciseId)",
                method: .delete, // Menggunakan metode HTTP DELETE
                responseType: DeleteExerciseResponse.self
            )
            
            if response.status == "success" {
                print(response.message)
                return true // Berhasil
            } else {
                self.isError = true
                self.errorMessage = response.message
                return false // Gagal
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal menghapus gerakan. Periksa koneksi Anda."
            print(error.localizedDescription)
            return false // Gagal karena error koneksi atau lainnya
        }
    }
}
