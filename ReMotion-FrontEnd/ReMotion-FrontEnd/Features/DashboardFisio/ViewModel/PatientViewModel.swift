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
    @Published var patients: [PatientListItem] = []
    @Published var users: [ReadUsersNonFisioData] = []
    @Published var patient: PatientDetail?
    @Published var fisioId: Int?
    @Published var patientId: Int?
    @Published var patientProgressDates: Set<Date> = []
    
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
        
        print("=== READ PATIENTS ===")
        print("fisioId: \(fisioId)")
        print("Endpoint: fisio/\(fisioId)/patients/")
        
        do {
            let response: ReadPatientResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/",
                method: .get,
                responseType: ReadPatientResponse.self
            )
            self.readPatientResponse = response
            
            if let responseData = readPatientResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.patients = responseData
                print("✅ Patients loaded: \(responseData.count)")
            } else {
                print("⚠️ Response data is nil")
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data pasien: \(error.localizedDescription)"
            print("❌ Read patients error: \(error)")
        }
    }
    
    func readPatientDetail(fisioId: Int, patientId: Int) async throws {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        print("=== READ PATIENT DETAIL ===")
        print("fisioId: \(fisioId)")
        print("patientId: \(patientId)")
        print("Endpoint: fisio/\(fisioId)/patients/\(patientId)")
        
        do {
            let response: ReadPatientDetailResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/\(patientId)",
                method: .get,
                responseType: ReadPatientDetailResponse.self
            )
            self.readPatientDetailResponse = response
            print("Response status: \(response.status)")
            
            let data = response.data
            self.errorMessage = ""
            self.isError = false
            self.patient = data
            
            if let progresses = data.progresses {
                self.patientProgressDates = Set(progresses.compactMap { $0.toDate() })
            } else {
                self.patientProgressDates = []
            }
            
            print("✅ Patient detail loaded successfully")
            print("Patient name: \(data.name)")
            print("Phase: \(data.phase)")
            print("Progress dates: \(self.patientProgressDates.count)")
        } catch let error as AFError {
            self.isError = true
            
            switch error {
            case .responseValidationFailed(let reason):
                self.errorMessage = "Validasi gagal: \(reason)"
                print("❌ Validation error: \(reason)")
            case .responseSerializationFailed(let reason):
                self.errorMessage = "Serialisasi gagal: \(reason)"
                print("❌ Serialization error: \(reason)")
            default:
                self.errorMessage = "Gagal mengambil detail pasien: \(error.localizedDescription)"
                print("❌ AFError: \(error)")
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil detail pasien: \(error.localizedDescription)"
            print("❌ Generic error: \(error)")
        }
    }
    
    func editPatientDetail(fisioId: Int, patientId: Int, phase: String, symptoms: [String], diagnostic: String? = nil) async -> Bool {
        isLoading = true
        errorMessage = ""
        isError = false
        
        defer {
            isLoading = false
        }
        
        let phaseId = PhaseUtil.phaseNumber(from: phase)
        
        print("=== EDIT PATIENT DETAIL ===")
        print("fisioId: \(fisioId)")
        print("patientId: \(patientId)")
        print("phase: \(phase)")
        print("phaseId: \(phaseId)")
        print("symptoms: \(symptoms)")
        print("diagnostic: \(diagnostic ?? "nil")")
        print("Endpoint: fisio/\(fisioId)/patients/edit/\(patientId)")
        
        var updateParams: [String: Any] = [
            "phaseId": phaseId,
            "symptoms": symptoms
        ]
        
        if let diagnostic = diagnostic, !diagnostic.isEmpty {
            updateParams["diagnostic"] = diagnostic
        }
        
        do {
            let response: EditPatientExerciseResponse = try await APIService.shared.requestAPI(
                "fisio/\(fisioId)/patients/edit/\(patientId)",
                method: .patch,
                parameters: updateParams,
                responseType: EditPatientExerciseResponse.self
            )
            
            if response.status == "success" {
                if let currentPatient = self.patient {
                    let updatedData = PatientDetail(
                        id: currentPatient.id,
                        name: currentPatient.name,
                        gender: currentPatient.gender,
                        phase: phase,
                        phoneNumber: currentPatient.phoneNumber,
                        dateOfBirth: currentPatient.dateOfBirth,
                        therapyStartDate: currentPatient.therapyStartDate,
                        diagnostic: diagnostic,
                        symptoms: symptoms,
                        exercises: currentPatient.exercises,
                        progresses: currentPatient.progresses
                    )
                    self.patient = updatedData
                    
                    if let progresses = updatedData.progresses {
                        self.patientProgressDates = Set(progresses.compactMap { $0.toDate() })
                    }
                }
                print("✅ Patient updated successfully")
                return true
            } else {
                self.isError = true
                self.errorMessage = response.message
                print("❌ Update failed: \(response.message)")
                return false
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengupdate data pasien: \(error.localizedDescription)"
            print("❌ Edit patient error: \(error)")
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
