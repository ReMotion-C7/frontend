//
//  DashboardFisioPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 23/10/25.
//

import SwiftUI

struct DashboardFisioPage: View {
    @State private var selectedMenu = "Pasien"
    @State private var searchText = ""
    @State private var showAddPatientModal = false
    @State private var navigateToAddGerakan = false
    
    let fisioId: Int
    
    @StateObject private var viewModel = PatientViewModel()
    
    var body: some View {
        NavigationSplitView {
            CustomSidebar(selectedMenu: $selectedMenu)
        } detail: {
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(selectedMenu == "Pasien" ? "Pasien" : "Gerakan Latihan")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.leading, 12)
                        
                        Spacer()
                        
                        Button(action: {
                            if selectedMenu == "Pasien" {
                                showAddPatientModal = true
                            } else {
                                navigateToAddGerakan = true
                            }
                        }) {
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
                    }
                    .padding(.bottom, 10)
                    
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
                    
                    // Content Cards
                    if selectedMenu == "Gerakan Latihan" {
                        // Gerakan Latihan Card
                        LibraryGerakanPage()
                    } else {
                        PatientListPage(viewModel: viewModel, fisioId: fisioId, searchText: searchText)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .sheet(isPresented: $showAddPatientModal, onDismiss: {
                    Task {
                        do {
                            try await viewModel.readPatients(fisioId: fisioId)
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    AddPatientModal(fisioId: fisioId)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.hidden)
                }

                .navigationDestination(isPresented: $navigateToAddGerakan) {
                    AddMovementPage()
                }
                .onChange(of: selectedMenu) { _ in
                    navigateToAddGerakan = false
                }
            }
        }
    }
}
