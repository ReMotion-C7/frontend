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
    
    let userId: Int
    
    @StateObject var viewModel = SessionViewModel()
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                CustomSidebarPatient(selectedMenu: $selectedMenu)
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
                            
                            VStack {
                                if viewModel.isLoading {
                                    LoadingView(message: "Memuat sesi latihan anda...")
                                }
                                else if viewModel.errorMessage != "" {
                                    ErrorView(message: viewModel.errorMessage)
                                }
                                else {
                                    ScrollView {
                                        VStack(spacing: 16) {
                                            ForEach(viewModel.sessions) { exercise in
                                                NavigationLink(destination: DetailExercisePage(userId: userId, exerciseId: exercise.id, viewModel: viewModel)) {
                                                    ExerciseSessionCard(exercise: exercise)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            showSafetyModal = true
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
                            .onAppear {
                                Task {
                                    try await viewModel.readSessions(patientId: userId)
                                }
                            }
                            
                        } else {
                            // Isi pake evaluasi gerakan
                            Text("Ini Evaluasi Gerakan")
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .onChange(of: selectedMenu) { _ in }
                    
                    /*
                     .background(
                     NavigationLink(
                     destination: ExercisePage(),
                     isActive: $navigateToExercisePage,
                     label: { EmptyView() }
                     )
                     ) // tolong di uncomment kalo udah ada ExercisePage
                     */
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

//#Preview {
//    SessionPage()
//}
