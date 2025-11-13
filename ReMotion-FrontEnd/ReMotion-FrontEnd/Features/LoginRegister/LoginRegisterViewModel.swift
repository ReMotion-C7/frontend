//
//  LoginRegisterViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import Foundation
import Combine
import Alamofire

@MainActor
class LoginRegisterViewModel: ObservableObject {
    
    @Published var errorMessage: String? = nil
    
    @Published var authResponse: AuthResponse? = nil
    
    @Published var session: SessionManager? = nil
    
    var isLoading: Bool = false
    
    init() {}
    
    func login(identifier: String, password: String) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: AuthResponse = try await APIService.shared.requestAPI(
                "auth/login",
                method: .post,
                parameters: ["identifier": identifier, "password": password],
                responseType: AuthResponse.self
            )
            authResponse = response
            if let data = authResponse?.data {
                self.errorMessage = ""
                session?.login(token: data.accessToken, role: data.user.roleId, userId: data.user.id, patientId: data.user.patientId)
            }
        } catch {
            self.errorMessage = "Gagal masuk! Pastikan akun anda sudah terdaftar."
        }
    }
    
    func register(email: String, name: String, password: String, phoneNumber: String, dateOfBirth: String, genderId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: AuthResponse = try await APIService.shared.requestAPI(
                "auth/register",
                method: .post,
                parameters: [
                    "email": email,
                    "name": name,
                    "password": password,
                    "phoneNumber": phoneNumber,
                    "dateOfBirth": dateOfBirth,
                    "genderId": genderId
                ],
                responseType: AuthResponse.self
            )
            authResponse = response
            print(response)
            if let data = authResponse?.data {
                self.errorMessage = ""
                session?.login(token: data.accessToken, role: data.user.roleId, userId: data.user.id, patientId: data.user.patientId)
            }
        } catch {
            print(error)
            self.errorMessage = "Gagal mendaftarkan akun! Periksa kembali input anda."
        }
    }
}
