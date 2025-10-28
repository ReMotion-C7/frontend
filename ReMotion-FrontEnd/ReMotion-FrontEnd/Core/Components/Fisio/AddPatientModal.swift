//
//  AddPatientModal.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 27/10/25.
//

import SwiftUI

struct AddPatientModal: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedPatient: Patient?
    @State private var therapyStartDate = Date()
    @State private var symptoms: [String] = []
    @State private var newSymptom = ""
    @State private var showDatePicker = false
    @State private var showSymptomInput = false
    
    let availablePatients = samplePatients
    
    var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return []
        }
        return availablePatients.filter { patient in
            patient.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Tambah Pasien")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Color.clear
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Masukkan Nama Pasien")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        HStack {
                            if selectedPatient != nil {
                                Text(searchText)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            } else {
                                TextField("Daniel", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 15))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        .padding()
                        .background(Color.gray.opacity(selectedPatient != nil ? 0.05 : 0.1))
                        .cornerRadius(8)
                    }
                    
                    if !searchText.isEmpty && !filteredPatients.isEmpty && selectedPatient == nil {
                        VStack(spacing: 8) {
                            ForEach(filteredPatients) { patient in
                                Button(action: {
                                    selectedPatient = patient
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.black)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(patient.name)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.black)
                                            Text(patient.phoneNumber)
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    
                    if let patient = selectedPatient {
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(patient.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.black)
                                Text(patient.phoneNumber)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tanggal Mulai Terapi")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                showDatePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.black)
                                    
                                    Text(formatDate(therapyStartDate))
                                        .font(.system(size: 15))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            if showDatePicker {
                                DatePicker("", selection: $therapyStartDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.vertical, 8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Gejala Pasien")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
        
                            ForEach(symptoms.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.gray)
                                    
                                    Text(symptoms[index])
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        symptoms.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                            }
                            
                            if showSymptomInput {
                                HStack(spacing: 12) {
                                    TextField("Tambahkan gejala", text: $newSymptom)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .font(.system(size: 14))
                                    
                                    Button(action: {
                                        if !newSymptom.isEmpty {
                                            symptoms.append(newSymptom)
                                            newSymptom = ""
                                            showSymptomInput = false
                                        }
                                    }) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14))
                                            .foregroundColor(.green)
                                    }
                                    
                                    Button(action: {
                                        newSymptom = ""
                                        showSymptomInput = false
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            } else {
                                Button(action: {
                                    showSymptomInput = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text("Tambahkan gejala")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            
            Button(action: {
                addPatient()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Tambah Pasien")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(selectedPatient != nil ? Color.black : Color.gray.opacity(0.4))
                .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .disabled(selectedPatient == nil)
        }
        .background(Color.white)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func addPatient() {
        guard let patient = selectedPatient else { return }
        
        print("Adding patient: \(patient.name)")
        print("Phone: \(patient.phoneNumber)")
        print("Gender: \(patient.gender)")
        print("Birth Date: \(patient.dateOfBirth)")
        print("Therapy Start: \(patient.therapyStartDate)")
        print("Phase: \(patient.phase)")
        print("Symptoms: \(patient.symptoms.joined(separator: ", "))")
        
        dismiss()
    }
}

#Preview {
    AddPatientModal()
}
