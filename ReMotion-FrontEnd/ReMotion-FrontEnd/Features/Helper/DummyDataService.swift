//
//  DummyDataService.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 30/10/25.
//

import Foundation

struct DummyDataService {
    
    // This function simulates making a network call to get exercises for a specific patient.
    // In the real app, this function's body would be replaced with an actual API call.
    static func fetchExercises(for patientId: String) -> [NewExercises] {
        print("Simulating network call for patient ID: \(patientId)...")
        
        // Here is our high-quality dummy data with the real video URLs.
        // This is the data that will be passed to your ExerciseSessionView.
        let exercisesForPatient: [NewExercises] = [
            NewExercises(
                id: 1,
                name: "Squat",
                method: "Repetition",
                video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/Squat%20Landscape.mp4",
                muscle: "Quadriceps",
                set: 3,
                repOrTime: 10
            ),
            NewExercises(
                id: 2,
                name: "Lunges",
                method: "Repetisi",
                video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/Lunges%20Landscape.mp4",
                muscle: "Quadriceps",
                set: 3,
                repOrTime: 10
            ),
            NewExercises(
                id: 3,
                name: "Single Leg Balance",
                method: "Waktu",
                video: "https://tjyoilicubnsdpujursp.supabase.co/storage/v1/object/public/ReMotion/One%20Leg%20Balance%20Landscape.mp4",
                muscle: "Whole Legs Balance",
                set: 3,
                repOrTime: 10
            )
        ]
        
        return exercisesForPatient
    }
}
