//
//  LoginRegisterModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

struct AuthResponse: Codable {
    var status: String
    var message: String
    var data: AuthData?
}

struct AuthData: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: String
    var user: UserData
}

struct UserData: Codable {
    var id: Int
    var name: String
    var roleId: Int
    var patientId: Int
}
