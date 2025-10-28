//
//  SessionPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI

struct SessionPage: View {
    @State private var selectedMenu = "Sesi Latihan"
    
    var body: some View {
        NavigationSplitView {
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Title
                    HStack {
                        Text(selectedMenu == "Sesi Latihan" ? "Sesi Latihan" : "Evaluasi Gerakan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 12)
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // Content Cards
                    if selectedMenu == "Sesi Latihan" {
                        
                    } else {
                        
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .onChange(of: selectedMenu) { _ in
                }
            }
        }
    }
}

#Preview {
    SessionPage()
}
