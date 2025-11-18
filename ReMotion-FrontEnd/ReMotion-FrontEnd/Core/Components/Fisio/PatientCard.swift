//
//  PatientCard.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import SwiftUI

struct PatientCard: View {
    let patient: PatientListItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Picture
                Circle()
                    .fill(Color.white)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    // Name
                    HStack(spacing: 12) {
                        Text(patient.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        // Phase
                        Text("\(patient.phase)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(patient.getPhaseColor())
                            .cornerRadius(4)
                    }
                    
                    // DOB and Phone Number
                    HStack(spacing: 4) {
                        Text(patient.phoneNumber)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("|")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Lahir: \(DateHelper.formatDateForDisplay(dateString: patient.dateOfBirth))")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            
            Divider()
            
            // Therapy Start Date
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                Text("Mulai terapi: \(DateHelper.formatDateForDisplay(dateString: patient.therapyStartDate))")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(20)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    PatientCard(patient: samplePatients[0])
//}
