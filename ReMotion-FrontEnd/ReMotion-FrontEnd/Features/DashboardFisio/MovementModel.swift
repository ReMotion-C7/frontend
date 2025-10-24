//
//  MovementModel.swift
//  ReMotion-FrontEnd
//
//  Created by Daniel Fernando Herawan on 24/10/25.
//

import Foundation

struct Movement: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let category: String
    let label: String
    let description: String
}

// Dummy
let sampleMovements: [Movement] = [
    Movement(
        imageName: "photo",
        title: "Quadriceps Set",
        category: "Otot Paha Depan",
        label: "Waktu",
        description: "Latihan ini dilakukan dengan posisi duduk atau berbaring, lalu mengencangkan otot paha depan seolah-olah mendorong bagian belakang lutut ke permukaan di bawahnya."
    ),
    Movement(
        imageName: "photo",
        title: "Ankle Pump",
        category: "Otot Betis",
        label: "Repetisi",
        description: "Latihan fisik yang dipergunakan untuk melatih otot pada betis dan pergelangan kaki. Ankle pumping exercise dapat dilakukan dengan melakukan gerakan."
    ),
    Movement(
        imageName: "photo",
        title: "Bridging Ringan",
        category: "Otot Pinggul",
        label: "Waktu",
        description: "Latihan fisik yang dilakukan dengan berbaring telentang, menekuk lutut, dan mengangkat pinggul ke atas untuk membentuk 'jembatan' dengan tubuh."
    ),
    Movement(
        imageName: "photo",
        title: "Heel Slide",
        category: "Otot Paha Belakang",
        label: "Repetisi",
        description: "Latihan ini bertujuan untuk melatih fleksibilitas otot paha belakang dengan cara menggeser tumit maju dan mundur di permukaan."
    )
]
