//
//  MovementModel.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import Foundation

struct Movement: Identifiable {
    let id: Int
    let name: String
    let type: String
    let description: String
    let muscle: String
    let image: String
}

// Dummy
let sampleMovements: [Movement] = [
    Movement(
        id: 1,
        name: "Quadriceps Set",
        type: "Waktu",
        description: "Latihan ini dilakukan dengan posisi duduk atau berbaring, lalu mengencangkan otot paha depan seolah-olah mendorong bagian belakang lutut ke permukaan di bawahnya.",
        muscle: "Otot Paha Depan",
        image: "photo"
    ),
    Movement(
        id: 2,
        name: "Ankle Pump",
        type: "Repetisi",
        description: "Latihan fisik yang dipergunakan untuk melatih otot pada betis dan pergelangan kaki. Ankle pumping exercise dapat dilakukan dengan melakukan gerakan naik-turun pergelangan kaki.",
        muscle: "Otot Betis",
        image: "photo"
    ),
    Movement(
        id: 3,
        name: "Bridging Ringan",
        type: "Waktu",
        description: "Latihan fisik yang dilakukan dengan berbaring telentang, menekuk lutut, dan mengangkat pinggul ke atas untuk membentuk 'jembatan' dengan tubuh.",
        muscle: "Otot Pinggul",
        image: "photo"
    ),
    Movement(
        id: 4,
        name: "Heel Slide",
        type: "Repetisi",
        description: "Latihan ini bertujuan untuk melatih fleksibilitas otot paha belakang dengan cara menggeser tumit maju dan mundur di permukaan.",
        muscle: "Otot Paha Belakang",
        image: "photo"
    )
]
