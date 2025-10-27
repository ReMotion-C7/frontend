//
//  DashboardFisioPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

enum FisioDestination: String, Hashable {
    case addMovement
}

struct DashboardFisioPage: View {
    @State private var selectedMenu = "Pasien"
    @State private var searchText = ""
    @State private var isShowingAddPasien = false
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            // Detail area
            NavigationStack {
                mainDashboardView
                    .sheet(isPresented: $isShowingAddPasien) {
                        NavigationStack {
                            AddPasienPage()
                                .navigationTitle("Tambah Pasien Baru")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button("Tutup") {
                                            isShowingAddPasien = false
                                        }
                                    }
                                }
                        }
                    }
            }
        }
        // ✅ Letakkan navigationDestination DI LUAR NavigationStack
        // agar bisa diakses oleh seluruh NavigationLink di dalam NavigationSplitView
        .navigationDestination(for: FisioDestination.self) { destination in
            switch destination {
            case .addMovement:
                AddMovementPage()
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Tambah Gerakan Latihan")
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
            }
        }
    }
    
    // MARK: - Main Dashboard View
    private var mainDashboardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(selectedMenu == "Pasien" ? "Pasien" : "Gerakan Latihan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                if selectedMenu == "Gerakan Latihan" {
                    // ✅ Link ini sekarang bisa menemukan destination
//                    NavigationLink(value: FisioDestination.addMovement) {
//                        Label("Tambah Gerakan Baru", systemImage: "plus")
//                            .labelStyle(.titleAndIcon)
//                            .font(.headline)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 14)
//                            .foregroundColor(.white)
//                            .background(Color.black)
//                            .cornerRadius(10)
//                    }
//                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: AddMovementPage()) {
                        Label("Tambah Gerakan Baru", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    Button(action: {
                        isShowingAddPasien = true
                    }) {
                        Label("Tambah Pasien Baru", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 10)
            
            // Search Bar
            HStack {
                TextField(
                    "Cari \(selectedMenu == "Pasien" ? "pasien" : "gerakan") ...",
                    text: $searchText
                )
                .textFieldStyle(PlainTextFieldStyle())
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            
            // Content Section
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

struct AddPasienPage: View {
    var body: some View {
        Text("Halaman Tambah Pasien")
    }
}

#Preview {
    DashboardFisioPage()
}
