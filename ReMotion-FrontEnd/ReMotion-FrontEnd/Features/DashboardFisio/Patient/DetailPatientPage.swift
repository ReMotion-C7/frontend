//
//  DetailPatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//


import SwiftUI

struct DetailPatientPage: View {
    @ObservedObject var viewModel: PatientViewModel
    
    let fisioId: Int
    let patientId: Int
    
    @State private var selectedExercise: Exercise?
    @State private var showDeleteModal = false
    @State private var showExerciseSheet = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            if viewModel.isLoading {
                ProgressView("Memuat data...")
            }
            else if viewModel.errorMessage != "" {
                Text("Error: \(viewModel.errorMessage)")
            }
            else if let patientData = viewModel.patient {
                let patient = Patient(
                    id: patientData.id,
                    name: patientData.name,
                    gender: patientData.gender,
                    phase: patientData.phase,
                    phoneNumber: patientData.phoneNumber,
                    dateOfBirth: patientData.dateOfBirth,
                    therapyStartDate: patientData.therapyStartDate,
                    symptoms: patientData.symptoms,
                    exercises: patientData.exercises ?? []
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        patientHeaderSection(patient: patient)
                        therapyInfoSection(patient: patient)
                        symptomsSection(patient: patient)
                        exerciseListSection(patient: patient)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                .disabled(showDeleteModal || showEditModal)
                .background(Color.white)
                .navigationTitle("Detail Pasien")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EditPatientDetailPage(viewModel: viewModel, patient: patient)) {
                            Text("Ubah")
                            
                        }
                    }
                }
                .sheet(isPresented: $showExerciseSheet) {
                    MovementToPatientModal(selectedExercises: .constant(patient.exercises), patient: patient)
                }
            }
        }
        .overlay {
            if showDeleteModal, let exercise = selectedExercise {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showDeleteModal = false
                            }
                        }
                    DeleteModal(
                        showDeleteModal: $showDeleteModal,
                        exerciseName: exercise.name,
                        onConfirm: {
                            Task {
                                showDeleteModal = false
                                
                                let success = await viewModel.deletePatientExercise(
                                    fisioId: fisioId,
                                    patientId: patientId,
                                    exerciseId: exercise.id
                                )
                                
                                if success {
                                    try? await viewModel.readPatientDetail(fisioId: fisioId, patientId: patientId)
                                }
                            }
                        }
                    )
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(), value: showDeleteModal)
            }
        }
        .onAppear {
            Task {
                try await viewModel.readPatientDetail(fisioId: fisioId, patientId: patientId)
            }
        }
    }
    
    
    // components
    private func patientHeaderSection(patient: Patient) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.black)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(patient.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(patient.gender)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                        )
                }
                
                Text(patient.phoneNumber + " | " + formatDate(patient.dateOfBirth))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func therapyInfoSection(patient: Patient) -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text("Tanggal mulai terapi : \(formatDate(patient.therapyStartDate))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            HStack(spacing: 6) {
                Text("Fase \(patient.phase)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(patient.getPhaseColor())
            )
        }
    }
    
    private func symptomsSection(patient: Patient) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Gejala")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(patient.symptoms, id: \.self) { symptom in
                    Text("• \(symptom)")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.8))
                }
            }
        }
    }
    
    private func exerciseListSection(patient: Patient) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daftar Gerakan Latihan")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    showExerciseSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Tambah Gerakan")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black)
                    )
                }
            }
            
            if patient.exercises.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "figure.walk.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("Belum ada gerakan latihan ditambahkan")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Klik tombol 'Tambah Gerakan' untuk menambahkan")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .background(Color(UIColor.systemGray6).opacity(0.5))
                .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        
                        ForEach(patient.exercises) { exercise in
                            PatientExerciseCard(exercise: exercise)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "id_ID")
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}






