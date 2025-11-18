//
//  NewExerciseModel.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 10/11/25.
//

import Foundation
import QuickPoseCore

//struct JointConfig: Codable {
//    let type: JointType
//    let side: QuickPose.Side?
//    
//    enum JointType: String, Codable {
//        case knee
//        case hip
//        case elbow
//        case shoulder
//        case ankle
//    }
//    
//    enum Side: String, Codable {
//        case left
//        case right
//    }
//    
//    var quickPoseSide: QuickPose.Side {
//        switch side {
//        case .left:
//            return .left
//        case .right:
//            return .right
//        case .none:
//            return .left  // default
//        }
//    }
//}

struct JointConfig: Codable {
    let type: JointType
    let side: QuickPose.Side
    
    enum JointType: String, Codable {
        case knee
        case hip
        case elbow
        case shoulder
        case ankle
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case side
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(JointType.self, forKey: .type)
        
        let sideString = try container.decodeIfPresent(String.self, forKey: .side)
        if let sideString = sideString {
            side = sideString == "left" ? .left : .right
        } else {
            side = .left
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        let sideString = side == .left ? "left" : "right"
        try container.encode(sideString, forKey: .side)
        
//        if let side = side {
//            let sideString = side == .left ? "left" : "right"
//            try container.encode(sideString, forKey: .side)
//        }
    }
    
    init(type: JointType, side: QuickPose.Side) {
        self.type = type
        self.side = side
    }
}


struct NewExerciseAPIResponse: Codable {
    let data: [NewExercises]
}

struct NewExercises: Codable, Identifiable {
    let id: Int
    let name: String
    //    let type: String // "Repetition", "Repetisi", "Waktu"
    let method: String
    let video: String
    let muscle: String
    let set: Int
    let repOrTime: Int
    
    let jointsToTrack: [JointConfig]
    
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
