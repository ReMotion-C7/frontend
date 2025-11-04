//
//  Patient.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import Foundation
import SwiftUI

struct ReadPatientResponse: Codable {
    var status: String
    var message: String
    var data: [ReadPatientData]
}

struct ReadPatientData: Identifiable, Codable {
    var id: Int
    var name: String
    var phase: Int
    var phoneNumber: String
    var dateOfBirth: String
    var therapyStartDate: String
    
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

struct ReadPatientDetailResponse: Codable {
    var status: String
    var message: String
    var data: ReadPatientDetailData
}

enum Gender: String, CaseIterable {
    case laki = "Laki-laki"
    case perempuan = "Perempuan"
}

struct ReadPatientDetailData: Identifiable, Codable {
    let id: Int
    let name: String
    let gender: String
    let phase: Int
    let phoneNumber: String
    let dateOfBirth: String
    let therapyStartDate: String
    let symptoms: [String]
    let exercises: [Exercise]
    
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

struct EditPatientExerciseResponse: Codable {
    let status: String
    let message: String
}

struct Patient: Identifiable, Codable {
    let id: Int
    let name: String
    let gender: String
    let phase: Int
    let phoneNumber: String
    let dateOfBirth: String
    let therapyStartDate: String
    let symptoms: [String]
    let exercises: [Exercise]
    
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

struct Exercise: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let image: String
    let muscle: String
    let description: String
    var set: Int
    var repOrTime: Int
}

let samplePatients: [Patient] = [
    // Pasien 1
    Patient(
        id: 1,
        name: "Daniel Fernando",
        gender: "Laki-laki",
        phase: 1,
        phoneNumber: "0812345678",
        dateOfBirth: "2004-02-01",
        therapyStartDate: "2025-01-20",
        symptoms: [
            "Nyeri yang tajam dan tiba-tiba di lutut.",
            "Lutut terasa tidak stabil, goyah, atau seperti mau lepas saat digunakan untuk menumpu beban."
        ],
        exercises: [
            Exercise(
                id: 1,
                name: "Push Up",
                type: "Repetisi",
                image: "https://image.com/pushup",
                muscle: "Otot Dada dan Lengan",
                description: "Push up adalah latihan untuk memperkuat otot dada, bahu, dan triceps dengan menahan berat badan menggunakan tangan.",
                set: 3,
                repOrTime: 30
            ),
            Exercise(
                id: 2,
                name: "Wall Sit",
                type: "Waktu",
                image: "https://image.com/wallsit",
                muscle: "Otot Paha",
                description: "Wall sit dilakukan dengan posisi duduk bersandar pada dinding untuk melatih kekuatan otot paha dan stabilitas lutut.",
                set: 3,
                repOrTime: 30
            )
        ]
    ),
    
    // Pasien 2
    Patient(
        id: 2,
        name: "Rafi Fernando",
        gender: "Laki-laki",
        phase: 2,
        phoneNumber: "081234567",
        dateOfBirth: "2016-04-12",
        therapyStartDate: "2016-04-10",
        symptoms: [
            "Sulit menekuk lutut sepenuhnya setelah cedera.",
            "Otot paha terasa kaku atau menegang.",
            "Terkadang terasa nyeri tumpul saat berjalan lama atau naik tangga."
        ],
        exercises: [
            Exercise(
                id: 3,
                name: "Leg Raise",
                type: "Repetisi",
                image: "https://image.com/legraise",
                muscle: "Otot Paha Depan",
                description: "Latihan ini dilakukan dengan berbaring dan mengangkat kaki lurus untuk memperkuat otot paha depan tanpa menekan sendi lutut.",
                set: 3,
                repOrTime: 15
            ),
            Exercise(
                id: 4,
                name: "Ankle Pump",
                type: "Repetisi",
                image: "https://image.com/anklepump",
                muscle: "Otot Betis",
                description: "Gerakan naik-turun pada pergelangan kaki untuk meningkatkan sirkulasi darah dan mencegah kekakuan.",
                set: 3,
                repOrTime: 20
            ),
            Exercise(
                id: 5,
                name: "Bridging",
                type: "Waktu",
                image: "https://image.com/bridging",
                muscle: "Otot Pinggul dan Punggung Bawah",
                description: "Latihan dengan mengangkat pinggul sambil berbaring untuk memperkuat otot punggung bawah dan pinggul.",
                set: 3,
                repOrTime: 30
            )
        ]
    )
]
