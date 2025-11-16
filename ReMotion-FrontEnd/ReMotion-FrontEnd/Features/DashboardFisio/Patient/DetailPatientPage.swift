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
    
    @State private var showDeleteModal = false
    @State private var showEditModal = false
    @State private var selectedExercise: Exercise?
    @State private var showExerciseSheet = false
    @Environment(\.dismiss) var dismiss
    @State private var isShowingDeleteAlert = false
    @State private var isNavigatingToEdit = false
    @State private var dismissSheet = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Memuat data...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else if viewModel.errorMessage != "" {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red.opacity(0.6))
                    Text("Terjadi Kesalahan")
                        .font(.system(size: 18, weight: .semibold))
                    Text(viewModel.errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
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
                    exercises: patientData.exercises
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        patientHeaderSection(patient: patient)
                        therapyInfoSection(patient: patient)
                        complaintsSection(patient: patient)
                        
                        if let diagnostic = patientData.diagnostic, !diagnostic.isEmpty {
                            diagnosticSection(diagnostic: diagnostic)
                        }
                        
                        exerciseListSection(patient: patient)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .padding(24)
                .background(Color.white)
                .navigationTitle("Detail Pasien")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .medium))
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: EditPatientDetailPage(viewModel: viewModel, patient: patient, fisioId: fisioId)) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20, weight: .medium))
                            }
                
                    }
                }
                .sheet(isPresented: $showExerciseSheet) {
                    MovementToPatientModal(selectedExercises: .constant(patient.exercises), patientViewModel: viewModel, dismissSheet: $dismissSheet, patient: patient, fisioId: fisioId)
                }
                .onChange(of: dismissSheet) { newValue in
                    if newValue {
                        showExerciseSheet = false
                        dismissSheet = false
                    }
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
                            withAnimation(.spring()) {
                                showDeleteModal = false
                            }
                        }
                    )
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(), value: showDeleteModal)
            }
            if showEditModal, let selected = selectedExercise {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showEditModal = false
                            }
                        }
                    EditPatientExerciseModal(
                        exercise: selected,
                        viewModel: viewModel,
                        showEditModal: $showEditModal
                    )
                }
                .transition(.opacity.combined(with: .scale))
                .animation(.spring(), value: showEditModal)
            }
        }
        .onAppear {
            Task {
                try await viewModel.readPatientDetail(fisioId: fisioId, patientId: patientId)
                viewModel.fisioId = fisioId
                viewModel.patientId = patientId
            }
        }
    }
    
    private func patientHeaderSection(patient: Patient) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.black)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 26))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(patient.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(patient.gender == "Laki-laki" || patient.gender == "Laki - laki" ? "Laki - Laki" : patient.gender)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(UIColor.systemGray5))
                        )
                }
                
                Text(patient.phoneNumber + " | " + formatDate(patient.dateOfBirth))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
    private func therapyInfoSection(patient: Patient) -> some View {
        HStack(spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text("Mulai terapi : \(formatDate(patient.therapyStartDate))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(6)

            
            HStack(spacing: 6) {
                Text("Fase \(patient.phase) (Post-Op)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(patient.getPhaseColor())
            )
        }
    }
    
    private func complaintsSection(patient: Patient) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Keluhan Pasien")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(patient.symptoms, id: \.self) { symptom in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        Text(symptom)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
    
    private func diagnosticSection(diagnostic: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hasil Diagnosa")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text(diagnostic)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.7))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6).opacity(0.6))
                .cornerRadius(12)
        }
    }

    private func exerciseListSection(patient: Patient) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daftar Gerakan Latihan")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    showExerciseSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Tambah Gerakan")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
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
                        ForEach(Array(patient.exercises.enumerated()), id: \.offset) { index, exercise in
                            PatientExerciseCard(
                                exercise: exercise,
                                onEdit: {
                                    selectedExercise = exercise
                                    showEditModal = true
                                },
                                onDelete: {
                                    selectedExercise = exercise
                                    showDeleteModal = true
                                }
                            )
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
