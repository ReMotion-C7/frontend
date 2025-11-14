//
//  ContentView.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        Group {
            if session.isLoggedIn {
                switch session.userRole {
                case 1:
                    DashboardFisioPage(fisioId: session.userId!)
                case 2:
                    SessionPage(userId: session.userId!, patientId: session.patientId!)
                default:
                    VStack {
                        Text("Login Error!")
                        Text("Error: Unknown user role.")
                        Text("Received Role: \(String(session.userRole!))")
                            .padding()
                        
                        Button("Keluar") {
                            session.logout()
                        }
                    }
                }
            }
            else {
                LoginPage()
            }
        }
    }
}

#Preview {
    ContentView()
}
