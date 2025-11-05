//
//  EditDetailPatientPage.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 04/11/25.
//
import SwiftUI

struct EditPatientDetailPage: View {
    @ObservedObject var viewModel: PatientViewModel
    let patient: Patient
    
    @State private var selectedPhase: Int
    @State private var symptoms: [String]
    
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: PatientViewModel, patient: Patient) {
        self.viewModel = viewModel
        self.patient = patient
        
        _selectedPhase = State(initialValue: patient.phase)
        _symptoms = State(initialValue: patient.symptoms)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    patientHeaderSection(patient: patient)
                    therapyInfoSection(patient: patient)
                    
                    Divider()
                    
                    phaseEditorSection
                    
                    symptomsEditorSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            
            saveButtonSection
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Ubah Detail Pasien")
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
        }
    }
    
    
    private var phaseEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pilih Fase Pasien")
                .font(.system(size: 16, weight: .semibold))
            Menu {
                Button(action: { selectedPhase = 1 }) {
                    Text("Fase 1")
                }
                Button(action: { selectedPhase = 2 }) {
                    Text("Fase 2")
                }
                Button(action: { selectedPhase = 3 }) {
                    Text("Fase 3")
                }
            } label: {
                HStack {
                    Text("Fase \(selectedPhase)")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
        }
    }
    
    private var symptomsEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Gejala Pasien")
                .font(.system(size: 16, weight: .semibold))
            
            ForEach(symptoms.indices, id: \.self) { index in
                HStack {
                    TextField("Deskripsi gejala...", text: $symptoms[index])
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Button(action: {
                        symptoms.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(10)
                    }
                }
            }
            
            Button(action: {
                symptoms.append("")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Tambahkan gejala")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
            }
        }
    }
    
    private var saveButtonSection: some View {
        Button(action: {
            Task {
                // await viewModel.updatePatient(patientId: patient.id, newPhase: selectedPhase, newSymptoms: symptoms)
                print("Menyimpan perubahan...")
                dismiss()
            }
        }) {
            Text("Simpan Perubahan")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color.white.shadow(radius: 5))
    }
    
    
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
            
            Spacer()
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



