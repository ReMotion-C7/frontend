//
//  Patient.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 24/10/25.
//

import Foundation
import SwiftUI


protocol PhaseCompatible {
    var phase: String { get }
}

extension PhaseCompatible {
    func getPhaseColor() -> Color {
        switch phase {
        case "Fase 1 (Post-Op)":
            return Color("redPhase")
        case "Fase 2 (Post-Op)":
            return Color("redPhase")
        case "Fase 3 (Post-Op)":
            return Color("redPhase")
        case "Fase 4 (Post-Op)":
            return Color("redPhase")
        case "Pre-Op":
            return Color("orangePhase")
        case "Non-Op":
            return Color("greenPhase")
        default:
            return Color.gray
        }
    }
    
    func getPhaseNumber() -> Int {
        switch phase {
        case "Fase 1 (Post-Op)": return 1
        case "Fase 2 (Post-Op)": return 2
        case "Fase 3 (Post-Op)": return 3
        case "Fase 4 (Post-Op)": return 4
        case "Pre-Op": return 5
        case "Non-Op": return 6
        default: return 0
        }
    }
    
    func getPhaseDisplayText() -> String {
        return phase
    }
}

struct PhaseUtil {
    static let allPhases = [
        "Fase 1 (Post-Op)",
        "Fase 2 (Post-Op)",
        "Fase 3 (Post-Op)",
        "Fase 4 (Post-Op)",
        "Pre-Op",
        "Non-Op"
    ]
    
    static func phaseName(from number: Int) -> String {
        switch number {
        case 1: return "Fase 1 (Post-Op)"
        case 2: return "Fase 2 (Post-Op)"
        case 3: return "Fase 3 (Post-Op)"
        case 4: return "Fase 4 (Post-Op)"
        case 5: return "Pre-Op"
        case 6: return "Non-Op"
        default: return "Unknown"
        }
    }
    
    static func phaseNumber(from name: String) -> Int {
        switch name {
        case "Fase 1 (Post-Op)": return 1
        case "Fase 2 (Post-Op)": return 2
        case "Fase 3 (Post-Op)": return 3
        case "Fase 4 (Post-Op)": return 4
        case "Pre-Op": return 5
        case "Non-Op": return 6
        default: return 0
        }
    }
}


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
    var data: [PatientListItem]
}

struct PatientListItem: Identifiable, Codable, PhaseCompatible {
    var id: Int
    var name: String
    var phase: String
    var phoneNumber: String
    var dateOfBirth: String
    var therapyStartDate: String
}

struct ReadPatientDetailResponse: Codable {
    var status: String
    var message: String
    var data: PatientDetail
}

struct PatientDetail: Identifiable, Codable, PhaseCompatible {
    let id: Int
    let name: String
    let gender: String
    let phase: String
    let phoneNumber: String
    let dateOfBirth: String
    let therapyStartDate: String
    let diagnostic: String?
    let symptoms: [String]
    let exercises: [Exercise]?
    let progresses: [Progress]?
    
    init(
        id: Int,
        name: String,
        gender: String,
        phase: String,
        phoneNumber: String,
        dateOfBirth: String,
        therapyStartDate: String,
        diagnostic: String? = nil,
        symptoms: [String],
        exercises: [Exercise]? = nil,
        progresses: [Progress]? = nil
    ) {
        self.id = id
        self.name = name
        self.gender = gender
        self.phase = phase
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.therapyStartDate = therapyStartDate
        self.diagnostic = diagnostic
        self.symptoms = symptoms
        self.exercises = exercises
        self.progresses = progresses
    }
    
    func toPatient() -> Patient {
        return Patient(
            id: id,
            name: name,
            gender: gender,
            phase: phase,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth,
            therapyStartDate: therapyStartDate,
            symptoms: symptoms,
            exercises: exercises ?? [],
            diagnostic: diagnostic,
            progresses: progresses
        )
    }
}

struct Patient: Identifiable, Codable, PhaseCompatible {
    let id: Int
    let name: String
    let gender: String
    let phase: String
    let phoneNumber: String
    let dateOfBirth: String
    let therapyStartDate: String
    let symptoms: [String]
    let exercises: [Exercise]
    let diagnostic: String?
    let progresses: [Progress]?
    
    init(
        id: Int,
        name: String,
        gender: String,
        phase: String,
        phoneNumber: String,
        dateOfBirth: String,
        therapyStartDate: String,
        symptoms: [String] = [],
        exercises: [Exercise] = [],
        diagnostic: String? = nil,
        progresses: [Progress]? = nil
    ) {
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
    
    init(from listItem: PatientListItem, symptoms: [String] = [], exercises: [Exercise] = []) {
        self.id = listItem.id
        self.name = listItem.name
        self.gender = ""
        self.phase = listItem.phase
        self.phoneNumber = listItem.phoneNumber
        self.dateOfBirth = listItem.dateOfBirth
        self.therapyStartDate = listItem.therapyStartDate
        self.symptoms = symptoms
        self.exercises = exercises
        self.diagnostic = nil
        self.progresses = nil
    }
    
    init(from detail: PatientDetail) {
        self.id = detail.id
        self.name = detail.name
        self.gender = detail.gender
        self.phase = detail.phase
        self.phoneNumber = detail.phoneNumber
        self.dateOfBirth = detail.dateOfBirth
        self.therapyStartDate = detail.therapyStartDate
        self.symptoms = detail.symptoms
        self.exercises = detail.exercises ?? []
        self.diagnostic = detail.diagnostic
        self.progresses = detail.progresses
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type = "method"
        case image
        case muscle
        case description
        case set
        case repOrTime
    }
    
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

struct Progress: Identifiable, Codable {
    let id: Int
    let date: String
    
    // Helper method to convert string date to Date object
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
}


struct DeletePatientExerciseResponse: Codable {
    let status: String
    let message: String
}

struct EditPatientExerciseResponse: Codable {
    let status: String
    let message: String
}

struct AssignPatientExerciseResponse: Codable {
    let status: String
    let message: String
}

enum Gender: String, CaseIterable {
    case laki = "Laki-laki"
    case perempuan = "Perempuan"
}

extension String {
    func toPhaseNumber() -> Int {
        return PhaseUtil.phaseNumber(from: self)
    }
}

extension Int {
    func toPhaseName() -> String {
        return PhaseUtil.phaseName(from: self)
    }
}

struct DateFormatHelper {
    static func format(_ dateString: String, from inputFormat: String = "yyyy-MM-dd", to outputFormat: String = "dd MMMM yyyy", locale: Locale = Locale(identifier: "id_ID")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = outputFormat
            dateFormatter.locale = locale
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
