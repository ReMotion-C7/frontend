//
//  DashboardExample.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardExample: View {
    @State private var selectedMenu = "Pasien"
    
    var body: some View {
        NavigationSplitView {
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            VStack(alignment: .leading, spacing: 10) {
                Text(selectedMenu == "Pasien" ? "Daftar Pasien" : "Daftar Gerakan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                    .padding(.bottom, 20)
                
                HStack(spacing: 20) {
//                    DashboardCardSmall(title: "Card 1", subtitle: "Contoh konten")
//                    DashboardCardSmall(title: "Card 2", subtitle: "Contoh konten")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    DashboardExample()
}
