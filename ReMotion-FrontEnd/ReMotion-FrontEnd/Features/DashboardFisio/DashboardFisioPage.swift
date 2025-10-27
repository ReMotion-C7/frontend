//
//  DashboardFisioPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

enum FisioDestination: String, Hashable {
    case addMovement
    case addPasien
}

struct DashboardFisioPage: View {
    @State private var selectedMenu = "Pasien"
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            // Content
            NavigationStack {
                mainDashboardView
                    .navigationDestination(
                        for: FisioDestination.self
                    ) { destination in
                        switch destination {
                        case .addMovement:
                            AddMovementPage()
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Tambah Gerakan Latihan")
                                            .font(
                                                .system(size: 28, weight: .bold)
                                            )
                                    }
                                }
                            
                        case .addPasien:
                            Text("Add Pasien Page")
                            //                            AddPasienPage()
                            //                                .toolbar {
                            //                                    ToolbarItem(placement: .principal) {
                            //                                        Text("Tambah Pasien")
                            //                                            .font(
                            //                                                .system(size: 28, weight: .bold)
                            //                                            )
                            //                                    }
                            //                                }
                        }
                    }
                    .onChange(of: selectedMenu) { _ in
                    }
            }
        }
    }
    
    private var mainDashboardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text(selectedMenu == "Pasien" ? "Pasien" : "Gerakan Latihan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                
                Spacer()
                
                NavigationLink(
                    value: selectedMenu == "Pasien" ? FisioDestination.addPasien : FisioDestination.addMovement
                ) {
                    Label(
                        selectedMenu == "Pasien" ? "Tambah Pasien Baru" : "Tambah Gerakan Baru",
                        systemImage: "plus"
                    )
                    .labelStyle(.titleAndIcon)
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 55)
            }
            
            // Search Bar
            HStack {
                TextField("Cari \(selectedMenu == "Pasien" ? "pasien" : "gerakan") ...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            
            // Content
            if selectedMenu == "Gerakan Latihan" {
                LibraryGerakanPage()
            } else {
                PatientPage()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 40)
    }
}

#Preview {
    DashboardFisioPage()
}

