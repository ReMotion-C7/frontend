//
//  ReMotion_FrontEndApp.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

@main
struct ReMotion_FrontEndApp: App {
    
    @StateObject private var session: SessionManager
    
    init() {
        let sessionManagerInstance = SessionManager()

        _session = StateObject(wrappedValue: sessionManagerInstance)
        
        SessionManager.shared = sessionManagerInstance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
