//
//  PatientViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import Combine
import Foundation
import Alamofire

@MainActor
class PatientViewModel: ObservableObject {
    
    @Published var readPatientResponse: ReadPatientResponse?
    @Published var readPatientDetailResponse: ReadPatientDetailResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var patients: [ReadPatientData] = []
    @Published var patient: ReadPatientDetailData?
    @Published var fisioId: Int?
    @Published var patientId: Int?
    
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
    
    func readPatientDetail(fisioId: Int, patientId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        print("hhhh")

        do {
            let response: ReadPatientDetailResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)",
                method: .get,
                responseType: ReadPatientDetailResponse.self
            )
            self.readPatientDetailResponse = response
            print(response)
            if let data = readPatientDetailResponse?.data {
                print(fisioId)
                print(patientId)
                print(data)
                self.errorMessage = ""
                self.isError = false
                self.patient = data
            }
        } catch {
            self.isError = true
            print("hahahaha")
            self.errorMessage = "Gagal mengambil data detail pasien!"
        }
    }
    
    func editPatientExercise(
        fisioId: Int,
        patientId: Int,
        exerciseId: Int,
        set: Int,
        repOrTime: Int
    ) async {
        isLoading = true
        isError = false
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let response: EditPatientExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)/exercises/edit/\(exerciseId)",
                method: .patch,
                parameters: ["set": set, "repOrTime": repOrTime],
                responseType: EditPatientExerciseResponse.self
            )

            if response.status == "success" {
                self.isError = false
            } else {
                self.isError = true
                self.errorMessage = response.message
            }

        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengedit data gerakan!"
        }
    }
}
