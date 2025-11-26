//
//  NewExerciseModel.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 10/11/25.
//

import Foundation
import QuickPoseCore

import Foundation
import QuickPoseCore

enum JointType: String, Codable {
    case knee
    case hip
    case elbow
    case shoulder
    case ankle
}

struct JointConfig: Codable {
    let type: JointType
    let side: QuickPose.Side
    
    let idealAngle: Double
    let tolerance: Double
    let clockwiseDirection: Bool
    
    var key: String {
        let sideString = (side == .left) ? "left" : "right"
        return "\(type.rawValue)_\(sideString)"
    }
        
    enum CodingKeys: String, CodingKey {
        case type
        case side
    }
    
    init(type: JointType, side: QuickPose.Side, idealAngle: Double, tolerance: Double, clockwiseDirection: Bool) {
        self.type = type
        self.side = side
        self.idealAngle = idealAngle
        self.tolerance = tolerance
        self.clockwiseDirection = clockwiseDirection
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(JointType.self, forKey: .type)
        
        let sideString = try container.decode(String.self, forKey: .side)
        self.side = sideString == "left" ? .left : .right
        
        self.idealAngle = 0.0
        self.tolerance = 0.0
        self.clockwiseDirection = true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        let sideString = side == .left ? "left" : "right"
        try container.encode(sideString, forKey: .side)
    }
}


struct NewExerciseAPIResponse: Codable {
    let data: [NewExercises]
}

struct NewExercises: Codable, Identifiable {
    let id: Int
    let name: String
    let method: String
    let video: String
    let muscle: String
    let set: Int
    let repOrTime: Int
    
    var jointsToTrack: [JointConfig]
}

struct NewOldExercises: Codable, Identifiable {
    let id: Int
    let name: String
    let method: String
    let video: String
    let muscle: String
    let set: Int
    let repOrTime: Int
}

// VERSION 2
struct NewExercisesV2: Codable, Identifiable {
    let id: Int
    let name: String
    let method: String // "Repetisi", "Waktu"
    let video: String
    let muscle: String
    let set: Int
    let repOrTime: Int
}

struct NewNextExerciseInfo {
    let name: String
    let video: String
    let muscle: String
    let setInfo: String // e.g., "3x10 Rep" or "3x10 Detik"
}

enum NewWorkoutPhase {
    case exercise(details: NewExercises, currentSet: Int)
    case rest(duration: TimeInterval, nextExercise: NewNextExerciseInfo)
}

struct NewReadSessionsResponse: Codable {
    var status: String
    var message: String
    var data: [Session]?
}

struct NewReadSessionExerciseDetailResponse: Codable {
    var status: String
    var message: String
    var data: SessionExerciseDetail
}

struct NewSession: Identifiable, Codable {
    var id: Int
    var name: String
    var type: String
    var image: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}

// VERSION 2
struct NewSessionV2: Identifiable, Codable {
    var id: Int
    var name: String
    var method: String
    var image: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}

struct NewSessionExerciseDetail: Identifiable, Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var video: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}

// VERSION 2
struct NewSessionExerciseDetailV2: Identifiable, Codable {
    var id: Int
    var name: String
    var method: String
    var description: String
    var video: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}


struct PatientProgressDate: Codable, Identifiable {
    let id: Int
    let date: Date
}

struct ProgressDateApiResponse: Codable {
    let status: String
    let message: String
    let data: [PatientProgressDate]
}

struct AddProgressResponse: Codable {
    let status: String
    let message: String
}
