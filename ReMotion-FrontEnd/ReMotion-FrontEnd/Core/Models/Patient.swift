//
//  Patient.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import Foundation
import SwiftUI

enum Gender: String, CaseIterable {
    case laki = "Laki-laki"
    case perempuan = "Perempuan"
}

struct Patient: Identifiable {
    let id = UUID()
    let name: String
    let gender: Gender
    let phase: Int
    let phoneNumber: String
    let birthDate: String
    let therapyDate: String
    
    public func getPhaseColor() -> Color {
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
}

let dummyPatient: [Patient] = [
    Patient(
        name: "Daniel Fernando",
        gender: .laki,
        phase: 1,
        phoneNumber: "+62 894 2871 2837",
        birthDate: "12 Juli 1996",
        therapyDate: "12 Juli 1996"
    ),
    Patient(
        name: "Jennie Kim",
        gender: .perempuan,
        phase: 2,
        phoneNumber: "+62 894 2871 2837",
        birthDate: "17 Agustus 2004",
        therapyDate: "12 Juli 1996"
    ),
    Patient(
        name: "Yobel Fernando",
        gender: .laki,
        phase: 3,
        phoneNumber: "+62 894 2871 2837",
        birthDate: "1 Februari 1945",
        therapyDate: "12 Juli 2025"
    )
]
