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
    @Published var editPatientResponse: ReadPatientDetailResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var patients: [ReadPatientDataV2] = []
    @Published var users: [ReadUsersNonFisioData] = []
    @Published var patient: ReadPatientDetailData?
    @Published var fisioId: Int?
    @Published var patientId: Int?
    
    func addPatient(fisioId: Int, userId: Int, phaseId: Int, therapyStartDate: String, symptoms: [String], diagnostic: String) async throws {
        print(fisioId)
        print(userId)
        print(phaseId)
        print(therapyStartDate)
        print(symptoms)
        print(diagnostic)
        do {
            let response: AddPatientResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/add",
                method: .post,
                parameters: [
                    "userId": userId,
                    "phaseId": phaseId,
                    "therapyStartDate": therapyStartDate,
                    "symptoms": symptoms,
                    "diagnostic": diagnostic
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
    
    //    func deletePatient(fisioId: Int, patientId: Int) async throws {
    //
    //        isLoading = true
    //        defer {
    //            isLoading = false
    //        }
    //
    //        do {
    //
    //            let response: BaseResponse = try await APIService.shared.requestAPI(
    //                "fisio/\(fisioId)/patients/\(patientId)",
    //                method: .delete,
    //                responseType: BaseResponse.self
    //            )
    //
    //            self.deletePatientResponse = response
    //            self.errorMessage = ""
    //            self.isError = false
    //            print("Pasien berhasil dihapus")
    //
    //        } catch {
    //            self.isError = true
    //            self.errorMessage = "Gagal menghapus data pasien!"
    //            print(error.localizedDescription)
    //        }
    //    }
    
    func editPatientDetail(fisioId: Int, patientId: Int, phase: Int, symptoms: [String]) async -> Bool {
        
        isLoading = true
        errorMessage = ""
        isError = false
        
        defer {
            isLoading = false
        }
        
        let updateParams: [String: Any] = [
            "phase": phase,
            "symptoms": symptoms
        ]
        
        do {
            let response: EditPatientExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/edit/\(patientId)", // URL sudah benar
                method: .patch,
                parameters: updateParams,
                responseType: EditPatientExerciseResponse.self // PERUBAHAN 2
            )
            
            if response.status == "success" {
                if let currentPatient = self.patient {
                    let updatedData = ReadPatientDetailData(
                        id: currentPatient.id,
                        name: currentPatient.name,
                        gender: currentPatient.gender,
                        phase: phase,
                        phoneNumber: currentPatient.phoneNumber,
                        dateOfBirth: currentPatient.dateOfBirth,
                        therapyStartDate: currentPatient.therapyStartDate,
                        symptoms: symptoms,
                        exercises: currentPatient.exercises
                    )
                    self.patient = updatedData
                }
                print("Pasien berhasil diupdate")
                return true
            } else {
                self.isError = true
                self.errorMessage = response.message
                return false
            }
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengupdate data pasien."
            print("Update Error: \(error.localizedDescription)")
            return false
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
    
    func assignPatientExercise(
        fisioId: Int,
        patientId: Int,
        exerciseId: Int,
        set: Int,
        repOrTime: Int
    ) async {
        
        defer {
            isLoading = false
        }
        
        print("fisioId:", fisioId)
        print("patientId:", patientId)
        print("exerciseId:", exerciseId)
        print("set:", set)
        print("repOrTime:", repOrTime)
        do {
            let response: AssignPatientExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)/exercises/assign",
                method: .post,
                parameters: [
                    "exerciseId": exerciseId,
                    "set": set,
                    "repOrTime": repOrTime
                ],
                responseType: AssignPatientExerciseResponse.self
            )
            
            if response.status == "success" {
                self.isError = false
            } else {
                self.isError = true
                self.errorMessage = response.message
            }
            
        } catch {
            self.isError = true
            self.errorMessage = "Gagal menambahkan gerakan ke pasien!"
        }
    }
    
    func deletePatientExercise(fisioId: Int, patientId: Int, exerciseId: Int) async -> Bool {
        isLoading = true
        isError = false
        errorMessage = ""
        do {
            let response: DeletePatientExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)/exercises/delete/\(exerciseId)",
                method: .delete,
                responseType: DeletePatientExerciseResponse.self
            )
            
            if response.status == "success" {
                print(response.message)
                return true
            } else {
                self.isError = true
                self.errorMessage = response.message
                return false
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal menghapus gerakan pasien. Periksa koneksi Anda."
            print(error.localizedDescription)
            return false
        }
    }
}

struct BaseResponse: Codable {
    let message: String?
}
