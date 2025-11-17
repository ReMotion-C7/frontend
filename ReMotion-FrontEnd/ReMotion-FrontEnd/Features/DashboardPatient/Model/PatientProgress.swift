//
//  Patient.swift
//  ReMotion-FrontEnd
//
//  Created by Louis Mario Wijaya on 17/11/25.
//

import Foundation
import SwiftUI

struct PatientProgress: Codable, Identifiable {
    let id: Int
    let date: String
}

struct ProgressApiResponse: Codable {
    let status: String
    let message: String
    let data: [PatientProgress]
}
