//
//  Exercise.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import Foundation

// MARK: - Models for Backend JSON Response

// This struct matches the root of the JSON response: {"data": [...]}
struct APIResponse: Codable {
    let data: [Exercises]
}

// This struct matches each exercise object in the "data" array
struct Exercises: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String // "Repetition", "Repetisi", "Waktu"
    let video: String
    let muscle: String
    let set: Int
    let repOrTime: Int
}

// MARK: - Models for App's Internal Logic

// A simple struct to hold information about the upcoming exercise for the rest screen
struct NextExerciseInfo {
    let name: String
    let video: String
    let muscle: String
    let setInfo: String // e.g., "3x10 Rep" or "3x10 Detik"
}

// This is the core of our logic. A workout is a series of phases.
// An enum is perfect here because a phase can only be one of two things.
enum WorkoutPhase {
    case exercise(details: Exercises, currentSet: Int)
    case rest(duration: TimeInterval, nextExercise: NextExerciseInfo)
}

struct ReadSessionsResponse: Codable {
    var status: String
    var message: String
    var data: [Session]
}

struct ReadSessionExerciseDetailResponse: Codable {
    var status: String
    var message: String
    var data: SessionExerciseDetail
}

struct Session: Identifiable, Codable {
    var id: Int
    var name: String
    var type: String
    var image: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}

struct SessionExerciseDetail: Identifiable, Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var video: String
    var muscle: String
    var set: Int
    var repOrTime: Int
}
