//
//  Patient.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import Foundation
import SwiftUI

struct AddPatientResponse: Codable {
    var status: String
    var message: String
}

struct ReadUsersNonFisioResponse: Codable {
    var status: String
    var message: String
    var data: [ReadUsersNonFisioData]
}

struct ReadUsersNonFisioData: Identifiable, Codable {
    var id: Int
    var name: String
    var phoneNumber: String
}

struct ReadPatientResponse: Codable {
    var status: String
    var message: String
    var data: [ReadPatientDataV2]
}

struct ReadPatientData: Identifiable, Codable {
    var id: Int
    var name: String
    var phase: Int
    var phoneNumber: String
    var dateOfBirth: String
    var therapyStartDate: String
    
    // Custom decoding untuk handle phase sebagai String dari backend
    enum CodingKeys: String, CodingKey {
        case id, name, phase, phoneNumber, dateOfBirth, therapyStartDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        dateOfBirth = try container.decode(String.self, forKey: .dateOfBirth)
        therapyStartDate = try container.decode(String.self, forKey: .therapyStartDate)
        
        // Handle phase - bisa String atau Int
        if let phaseInt = try? container.decode(Int.self, forKey: .phase) {
            // Jika backend kirim Int langsung
            phase = phaseInt
        } else if let phaseString = try? container.decode(String.self, forKey: .phase) {
            // Jika backend kirim String "Fase 4 (Post-Op)"
            phase = Self.extractPhaseNumber(from: phaseString)
        } else {
            phase = 0 // Default jika gagal decode
        }
    }
    
    // Initializer biasa untuk sample data
    init(id: Int, name: String, phase: Int, phoneNumber: String, dateOfBirth: String, therapyStartDate: String) {
        self.id = id
        self.name = name
        self.phase = phase
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.therapyStartDate = therapyStartDate
    }
    
    // Helper untuk extract number dari "Fase X (Post-Op)"
    private static func extractPhaseNumber(from phaseString: String) -> Int {
        // Cari pattern "Fase X" atau hanya angka
        let pattern = "Fase\\s*(\\d+)|^(\\d+)$"
        
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: phaseString, range: NSRange(phaseString.startIndex..., in: phaseString)) {
            
            // Cek group 1 (Fase X)
            if let range = Range(match.range(at: 1), in: phaseString) {
                if let number = Int(phaseString[range]) {
                    return number
                }
            }
            
            // Cek group 2 (angka saja)
            if let range = Range(match.range(at: 2), in: phaseString) {
                if let number = Int(phaseString[range]) {
                    return number
                }
            }
        }
        
        return 0 // Default jika tidak ditemukan
    }
    
    public func getPhaseColor() -> Color {
        switch phase {
        case 1:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case 2:
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case 3:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case 4:
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        default:
            return Color.gray
        }
    }
    
    public func getPhaseText() -> String {
        switch phase {
        case 1:
            return "Fase 1 (Pre-Op)"
        case 2:
            return "Fase 2 (Post-Op)"
        case 3:
            return "Fase 3 (Post-Op)"
        case 4:
            return "Fase 4 (Post-Op)"
        default:
            return "Fase \(phase)"
        }
    }
}

// VERSION 2
struct ReadPatientDataV2: Identifiable, Codable {
    var id: Int
    var name: String
    var phase: String
    var phoneNumber: String
    var dateOfBirth: String
    var therapyStartDate: String
    
    public func getPhaseColor() -> Color {
        switch phase {
        case "Fase 1 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 2 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 3 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 4 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Pre-Op":
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case "Non-Op":
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

struct DeletePatientExerciseResponse: Codable {
    let status: String
    let message: String
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
    let diagnostic: String?  // Field baru dari backend
    let symptoms: [String]
    let exercises: [Exercise]
    let progresses: [Progress]?  // Field baru dari backend
    
    // Custom decoding untuk handle phase sebagai String dari backend
    enum CodingKeys: String, CodingKey {
        case id, name, gender, phase, phoneNumber, dateOfBirth, therapyStartDate, diagnostic, symptoms, exercises, progresses
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        dateOfBirth = try container.decode(String.self, forKey: .dateOfBirth)
        therapyStartDate = try container.decode(String.self, forKey: .therapyStartDate)
        diagnostic = try? container.decode(String.self, forKey: .diagnostic)
        symptoms = try container.decode([String].self, forKey: .symptoms)
        exercises = try container.decode([Exercise].self, forKey: .exercises)
        progresses = try? container.decode([Progress].self, forKey: .progresses)
        
        // Handle phase - bisa String atau Int
        if let phaseInt = try? container.decode(Int.self, forKey: .phase) {
            phase = phaseInt
        } else if let phaseString = try? container.decode(String.self, forKey: .phase) {
            phase = Self.extractPhaseNumber(from: phaseString)
        } else {
            phase = 0
        }
    }
    
    // Initializer biasa untuk manual creation
    init(id: Int, name: String, gender: String, phase: Int, phoneNumber: String, dateOfBirth: String, therapyStartDate: String, symptoms: [String], exercises: [Exercise], diagnostic: String? = nil, progresses: [Progress]? = nil) {
        self.id = id
        self.name = name
        self.gender = gender
        self.phase = phase
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.therapyStartDate = therapyStartDate
        self.symptoms = symptoms
        self.exercises = exercises
        self.diagnostic = diagnostic
        self.progresses = progresses
    }
    
    private static func extractPhaseNumber(from phaseString: String) -> Int {
        let pattern = "Fase\\s*(\\d+)|^(\\d+)$"
        
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: phaseString, range: NSRange(phaseString.startIndex..., in: phaseString)) {
            
            if let range = Range(match.range(at: 1), in: phaseString) {
                if let number = Int(phaseString[range]) {
                    return number
                }
            }
            
            if let range = Range(match.range(at: 2), in: phaseString) {
                if let number = Int(phaseString[range]) {
                    return number
                }
            }
        }
        
        return 0
    }
    
    public func getPhaseColor() -> Color {
        switch phase {
        case 1:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case 2:
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case 3:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case 4:
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        default:
            return Color.gray
        }
    }
}

// VERSION 2
struct ReadPatientDetailDataV2: Identifiable, Codable {
    let id: Int
    let name: String
    let gender: String
    let phase: String
    let phoneNumber: String
    let diagnostic: String
    let dateOfBirth: String
    let therapyStartDate: String
    let symptoms: [String]
    let exercises: [Exercise]
    
    public func getPhaseColor() -> Color {
        switch phase {
        case "Fase 1 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 2 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 3 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 4 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Pre-Op":
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case "Non-Op":
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

struct AssignPatientExerciseResponse: Codable {
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
        case 4:
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        default:
            return Color.gray
        }
    }
}

// VERSION 2
struct PatientV2: Identifiable, Codable {
    let id: Int
    let name: String
    let gender: String
    let phase: String
    let phoneNumber: String
    let diagnostic: String
    let dateOfBirth: String
    let therapyStartDate: String
    let symptoms: [String]
    let exercises: [Exercise]
    
    public func getPhaseColor() -> Color {
        switch phase {
        case "Fase 1 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 2 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 3 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Fase 4 (Post-Op)":
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case "Pre-Op":
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case "Non-Op":
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
    
    // Custom CodingKeys untuk map "method" dari backend ke "type"
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type = "method"  // Backend kirim "method", kita map ke "type"
        case image
        case muscle
        case description
        case set
        case repOrTime
    }
    
    // Initializer untuk manual creation (sample data)
    init(id: Int, name: String, type: String, image: String, muscle: String, description: String, set: Int, repOrTime: Int) {
        self.id = id
        self.name = name
        self.type = type
        self.image = image
        self.muscle = muscle
        self.description = description
        self.set = set
        self.repOrTime = repOrTime
    }
}

// MARK: - Progress Model
struct Progress: Identifiable, Codable {
    let id: Int
    let date: String
}

// VERSION 2
struct ExerciseV2: Identifiable, Codable {
    let id: Int
    let name: String
    let method: String
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
