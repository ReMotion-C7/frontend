//
//  DashboardFisioPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardFisioPage: View {
    @State private var selectedMenu = "Pasien"
    
    var body: some View {
        NavigationSplitView {
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title
                HStack {
                    Text(selectedMenu == "Pasien" ? "Pasien" : "Gerakan Latihan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    // Button Add
                    HStack {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                        Text(selectedMenu == "Pasien" ? "Tambah Pasien Baru" : "Tambah Gerakan Baru")
                            .fontWeight(.semibold)
                            .padding(.trailing, 10)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 6)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(8)
                    .padding(.trailing, 55)
                }
                .padding(.bottom, 10)
                
                // Search Bar
                HStack {
                    Text("Cari \(selectedMenu == "Pasien" ? "pasien" : "gerakan") ...")
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                
                // Content Cards
                if selectedMenu == "Gerakan Latihan" {
                    // Gerakan Latihan Card
                    LibraryGerakanPage()
                } else {
                    PasienPage()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 40)
        }
    }
}

#Preview {
    DashboardFisioPage()
}
