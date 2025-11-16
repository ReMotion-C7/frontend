//
//  NewExerciseModel.swift
//  ReMotion-FrontEnd
//
//  Created by Rafi Abhista  on 10/11/25.
//

import Foundation


struct NewExerciseAPIResponse: Codable {
    let data: [NewExercises]
}

struct NewExercises: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String // "Repetition", "Repetisi", "Waktu"
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
