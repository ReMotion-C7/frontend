//
//  SessionPage.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 28/10/25.
//

import SwiftUI

struct SessionPage: View {
    @State private var selectedMenu = "Sesi Latihan"
    @State private var showSafetyModal = false
    @State private var navigateToExercisePage = false
    @State private var todaysExercises: [NewExercises] = []
    let userId: Int
    let patientId: Int
    @StateObject var viewModel = SessionViewModel()
    
    private var formattedCurrentDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                CustomSidebarPatient(selectedMenu: $selectedMenu)
            } detail: {
                NavigationStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(selectedMenu == "Sesi Latihan" ? "Sesi Latihan" : "Progres Latihan")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Text(formattedCurrentDate)
                            .fontWeight(.semibold)
                            .padding(.top, 6)
                        
                        if selectedMenu == "Sesi Latihan" {
                            
                            VStack (alignment: .leading) {
                                if viewModel.isLoading {
                                    LoadingView(message: "Memuat sesi latihan anda...")
                                }
                                else if viewModel.errorMessage != "" {
                                    ErrorView(message: viewModel.errorMessage)
                                }
                                else {
                                    if viewModel.sessions.isEmpty {
                                        BlankView(message: "Masih belum ada sesi latihan untuk anda.")
                                    }
                                    else {
                                        VStack {
                                            HStack {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.gray)
                                                    .font(.title3)
                                                
                                                Text("Latihan di bawah ini telah disesuaikan oleh terapis Anda.")
                                                    .font(.default)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.secondary)
                                                
                                                Spacer()
                                            }
                                            .padding(.bottom, 6)
                                            
                                            Text("Mohon lakukan sesuai jumlah dan durasi yang dianjurkan, karena latihan berlebih dapat berisiko menimbulkan cedera atau memperlambat pemulihan.")
                                                .foregroundColor(Color(
                                                    red: 163/255,
                                                    green: 163/255,
                                                    blue: 163/255
                                                ))
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 16)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(12)
                                        .padding(.top, 12)
                                        
                                        
                                        
                                        ScrollView {
                                            VStack(alignment: .leading, spacing: 16) {
                                                ForEach(viewModel.sessions) { exercise in
                                                    NavigationLink(destination: DetailExercisePage(userId: patientId, exerciseId: exercise.id, viewModel: viewModel)) {
                                                        ExerciseSessionCard(exercise: exercise)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                }
                                            }
                                        }
                                        .padding(.top, 12)
                                        
                                        Button(action: {
                                            //                                            self.todaysExercises = DummyDataService.fetchExercises(for: "patient-123")
                                            Task {
                                                // because your function is async throws
                                                do {
                                                    self.todaysExercises = try await viewModel.readExercises(patientId: patientId)
                                                    
                                                    withAnimation(.spring()) {
                                                        showSafetyModal = true
                                                    }
                                                } catch {
                                                    print("Failed fetching exercises: \(error)")
                                                }
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "play.circle.fill")
                                                Text("Mulai Sesi Latihan")
                                                    .fontWeight(.semibold)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .padding(.top, 10)
                                        }
                                    }
                                    
                                }
                            }
                            .onAppear {
                                Task {
                                    try await viewModel.readSessions(patientId: patientId)
                                }
                            }
                        } else {
                            ProgressCalendarView(patientId: patientId)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 40)
                    .fullScreenCover(isPresented: $navigateToExercisePage) {
                        NavigationStack {
                            NewExerciseView(exercises: todaysExercises, patientId: patientId)
                        }
                    }
                    .onChange(of: selectedMenu) {}
                }
            }
            if showSafetyModal {
                Rectangle()
                    .fill(.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showSafetyModal = false
                        }
                    }
                SafetyModal(showModal: $showSafetyModal, navigateToExercisePage: $navigateToExercisePage)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}
