//
//  SessionModel.swift
//  ReMotion-FrontEnd
//
//  Created by Yobel Nathaniel Filipus on 30/10/25.
//

import Foundation

struct ReadSessionsResponse: Codable {
    var status: String
    var message: String
    var data: [Session]
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
