//
//  SessionViewModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 30/10/25.
//

import Combine
import Foundation
import Alamofire
import QuickPoseCore

class SessionViewModel: ObservableObject {
    
    @Published var readSessionResponses: ReadSessionsResponse?
    @Published var readNewExercisesResponse: ReadNewExercisesResponse?
    @Published var readSessionExerciseDetailResponse: ReadSessionExerciseDetailResponse?
    @Published var isLoading: Bool = false
    @Published var sessions: [SessionV2] = []
    @Published var sessionExercise: SessionExerciseDetailV2? = nil
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    
    @Published var newExercises: [NewExercises] = []
    
    func readExercises(patientId: Int) async throws -> [NewExercises] {
        do {
            let response: ReadNewExercisesResponse = try await APIService.shared.requestAPI(
                "patients/\(patientId)/sessions/exercises",
                method: .get,
                responseType: ReadNewExercisesResponse.self
            )
            
            print("DATA MASUK: \(response)")
            
            // unwrap data safely
            guard let rawData = response.data else {
                print("DATA KOSONG")
                self.newExercises = []
                return []
            }
            
            // convert each exercise to add jointsToTrack
            let converted = rawData.map { exercise in
                NewOldExercises(
                    id: exercise.id,
                    name: exercise.name,
                    method: exercise.method,
                    video: exercise.video,
                    muscle: exercise.muscle,
                    set: exercise.set,
                    repOrTime: exercise.repOrTime,
                )
            }
            
            let newConverted = converted.map { exercise in
                NewExercises(
                    id: exercise.id,
                    name: exercise.name,
                    method: exercise.method,
                    video: exercise.video,
                    muscle: exercise.muscle,
                    set: exercise.set,
                    repOrTime: exercise.repOrTime,
                    jointsToTrack: jointsForExercise(named: exercise.name)
                )
            }
            
            print("JADI GINI BANG: \(newConverted)")
            
            self.newExercises = newConverted
            return newConverted
            
        } catch {
            print("ERROR READ AI: \(error)")
            return []
        }
    }
    
    // mapping helper
    func jointsForExercise(named name: String) -> [JointConfig] {
        // normalize name for robust matching
        let key = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch key {
        case "lunges":
            return [
                .init(type: .knee, side: .left),
                .init(type: .knee, side: .right),
                .init(type: .hip,  side: .left),
                .init(type: .hip,  side: .right)
            ]
            
        case "squat":
            return [
                .init(type: .knee,  side: .left),
                .init(type: .knee,  side: .right),
                .init(type: .hip,   side: .left),
                .init(type: .hip,   side: .right),
                .init(type: .ankle, side: .left),
                .init(type: .ankle, side: .right)
            ]
            
            // match variations like "one leg balance", "one-leg balance", etc.
        case let s where s.contains("one leg") || s.contains("one-leg") || s.contains("oneleg"):
            // your example used left-side joints only — keep that or add logic to choose side
            return [
                .init(type: .ankle, side: .left),
                .init(type: .knee,  side: .left),
                .init(type: .hip,   side: .left)
            ]
            
        default:
            return []
        }
    }
    
    func readSessions(patientId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadSessionsResponse = try await APIService.shared.requestAPI(
                "patients/\(patientId)/sessions",
                method: .get,
                responseType: ReadSessionsResponse.self
            )
            self.readSessionResponses = response
            if let data = readSessionResponses?.data {
                self.errorMessage = ""
                self.isError = false
                self.sessions = data
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data detail pasien!"
        }
    }
    
    func readSessionExerciseDetail(patientId: Int, exerciseId: Int) async throws {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response: ReadSessionExerciseDetailResponse = try await APIService.shared.requestAPI(
                "patients/\(patientId)/sessions/exercises/\(exerciseId)",
                method: .get,
                responseType: ReadSessionExerciseDetailResponse.self
            )
            self.readSessionExerciseDetailResponse = response
            if let data = readSessionExerciseDetailResponse?.data {
                self.errorMessage = ""
                self.isError = false
                self.sessionExercise = data
                print(data)
            }
        } catch {
            self.isError = true
            self.errorMessage = "Gagal mengambil data detail pasien!"
        }
    }
}
