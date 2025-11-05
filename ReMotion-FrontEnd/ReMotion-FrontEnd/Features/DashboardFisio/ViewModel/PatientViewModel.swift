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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var patients: [ReadPatientData] = []
    @Published var patient: ReadPatientDetailData?
    
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
}
