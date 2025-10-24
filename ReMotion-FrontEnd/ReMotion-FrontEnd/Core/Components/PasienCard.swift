//
//  UserProfileCard.swift
//  ReMotion-FrontEnd
//
//  User profile card component
//

import SwiftUI

struct PasienCard: View {
    let name: String
    let phase: Int
    let phoneNumber: String
    let birthDate: String
    let startDate: String
    let therapyDate: String
    
    private func getPhaseColor() -> Color {
        switch phase {
        case 1:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case 2:
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case 3:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 16) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Text(name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        

                        Text("Fase \(phase)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(getPhaseColor())
                            .cornerRadius(4)
                    }
                    
                    HStack(spacing: 4) {
                        Text(phoneNumber)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("|")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text(birthDate)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            
            Divider()
            
           
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                Text("Mulai terapi: \(therapyDate)")
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

#Preview {
    VStack(spacing: 16) {
        PasienCard(
            name: "Daniel Fernando",
            phase: 1,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
        

        PasienCard(
            name: "Daniel Fernando",
            phase: 2,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
        
        PasienCard(
            name: "Daniel Fernando",
            phase: 3,
            phoneNumber: "+62 894 2871 2837",
            birthDate: "12 July 1996",
            startDate: "12 July 1996",
            therapyDate: "12 July 1996"
        )
    }
    .padding()
    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
}
