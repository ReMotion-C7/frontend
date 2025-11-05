//
//  SessionManager.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 29/10/25.
//

import Combine
import Foundation

class SessionManager: ObservableObject {
    
    static var shared: SessionManager!
    
    @Published var isLoggedIn: Bool = false
    @Published var userRole: Int?
    @Published var accessToken: String?
    @Published var userId: Int?
    
    private let accessTokenKey = "accessToken"
    private let userRoleKey = "userRole"
    private let userIdKey = "userId"
    
    init() {
        let token = UserDefaults.standard.string(forKey: accessTokenKey)
        let role = UserDefaults.standard.integer(forKey: userRoleKey)
        let id = UserDefaults.standard.integer(forKey: userIdKey)
        if let token = token, !token.isEmpty {
            self.isLoggedIn = true
            self.accessToken = token
            self.userRole = role
            self.userId = userId
            APIService.shared.accessToken = token
            if id != 0 {
                self.userId = id
                APIService.shared.userId = id
            }
        }
    }
    
    func login(token: String, role: Int, userId: Int) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
        UserDefaults.standard.set(role, forKey: userRoleKey)
        UserDefaults.standard.set(userId, forKey: userIdKey)
                
        APIService.shared.accessToken = token
        APIService.shared.userId = userId
        
        DispatchQueue.main.async {
            self.isLoggedIn = true
            self.accessToken = token
            self.userRole = role
            self.userId = userId
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: userRoleKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        
        APIService.shared.accessToken = nil
        APIService.shared.userId = nil
        APIService.shared.roleId = nil
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.accessToken = nil
            self.userRole = nil
            self.userId = nil
        }
        
        print(#function, "User has been logged out. IsLoggedIn: \(self.isLoggedIn)")
    }
    
}
