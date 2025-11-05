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
    @Published var deletePatientResponse: BaseResponse?
    @Published var readUsersNonFisioResponse: ReadUsersNonFisioResponse?
    @Published var addPatientResponse: AddPatientResponse?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var patients: [ReadPatientData] = []
    @Published var users: [ReadUsersNonFisioData] = []
    @Published var patient: ReadPatientDetailData?
    @Published var fisioId: Int?
    @Published var patientId: Int?
    
    func addPatient(fisioId: Int, userId: Int, phase: Int, therapyStartDate: String, symptoms: [String]) async throws {
        print(fisioId)
        print(userId)
        print(phase)
        print(therapyStartDate)
        print(symptoms)
        do {
            let response: AddPatientResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/add",
                method: .post,
                parameters: [
                    "userId": userId,
                    "phase": phase,
                    "therapyStartDate": therapyStartDate,
                    "symptoms": symptoms
                    ],
                responseType: AddPatientResponse.self
            )
            self.addPatientResponse = response
            self.errorMessage = ""
            self.isError = false
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data user yang belum terdaftar sebagai fisio!"
        }
        
    }
    
    func readUsersNonFisio(fisioId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadUsersNonFisioResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/users",
                method: .get,
                responseType: ReadUsersNonFisioResponse.self
            )
            self.readUsersNonFisioResponse = response
            if let data = readUsersNonFisioResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.users = data
            }
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data user yang belum terdaftar sebagai fisio!"
        }
    }
    
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
    
    func deletePatient(fisioId: Int, patientId: Int) async throws {
        
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
   
            let response: BaseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)",
                method: .delete,
                responseType: BaseResponse.self
            )
            
            self.deletePatientResponse = response
            self.errorMessage = ""
            self.isError = false
            print("Pasien berhasil dihapus")
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal menghapus data pasien!"
            print(error.localizedDescription)
        }
    }
}

struct BaseResponse: Codable {
   let message: String?
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
