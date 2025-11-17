//
//  MovementModel.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import Foundation

struct ReadExercisesResponse: Codable {
    var status: String
    var message: String
    var data: [Movement]
}

struct ReadExerciseDetailResponse: Codable {
    var status: String
    var message: String
    var data: MovementDetail
}

struct ReadModalExercisesResponse: Codable {
    let status: String
    let message: String
    let data: [ModalExercise]?
}

struct DeleteExerciseResponse: Codable {
    let status: String
    let message: String
}

struct ModalExercise: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let muscle: String
    let image: String
}

// VERSION 2
struct ModalExerciseV2: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let muscle: String
    let image: String
}

struct Movement: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let description: String
    let muscle: String
    let image: String
}

// VERSION 2
struct MovementV2: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let description: String
    let muscle: String
    let image: String
}

struct MovementDetail: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let description: String
    let muscle: String
    let video: String
}

// VERSION 2
struct MovementDetailV2: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let category: String
    let description: String
    let muscle: String
    let video: String
}

// Dummy
let sampleMovements: [Movement] = [
    Movement(
        id: 1,
        name: "Jumping Jacks",
        type: "AGA",
        category: "Keseimbangan",
        description: "A full-body exercise that increases aerobic fitness, strengthens muscles, and improves coordination.",
        muscle: "Seluruh Tubuh",
        image: "https://example.com/jumping_jacks.jpg"
    )
]

