//
//  ExerciseViewModelTests.swift
//  ReMotion-FrontEndTests
//
//  Created by Gabriela on 03/11/25.
//

import Testing
@testable import ReMotion_FrontEnd

@MainActor
@Suite("ExerciseViewModel Tests")
struct ExerciseViewModelTests {
    var viewModel: ExerciseViewModel!
    var sampleMovement: Movement!
    var sampleExistingExercises: [Exercise]!

    init() {
        viewModel = ExerciseViewModel()

        sampleMovement = Movement(
            id: 10,
            name: "Test Quadriceps Set",
            type: "Waktu",
            category: "ya",
            description: "Deskripsi tes.",
            muscle: "Otot Paha Depan",
            image: "test_image.png"
        )
        
        sampleExistingExercises = [
            Exercise(
                id: 1,
                name: "Exercise Lama 1",
                type: "Repetisi",
                image: "img1.png",
                muscle: "Otot 1",
                description: "Desc 1",
                set: 3,
                repOrTime: 10
            ),
            Exercise(
                id: 2,
                name: "Exercise Lama 2",
                type: "Waktu",
                image: "img2.png",
                muscle: "Otot 2",
                description: "Desc 2",
                set: 2,
                repOrTime: 30
            )
        ]
    }



    @Test("Buat exercise valid - Daftar kosong, ID harus 1")
    func testCreateExercise_validInputs_emptyList() throws {
        let sets = "3"
        let reps = "15"
        let currentExercises: [Exercise] = []
        
        let newExercise = viewModel.createExercise(
            from: sampleMovement,
            setsString: sets,
            repOrTimeString: reps,
            currentExercises: currentExercises
        )
        
        let unwrappedExercise = try #require(newExercise, "Exercise seharusnya tidak nil untuk input yang valid.")
        
        #expect(unwrappedExercise.id == 1, "ID harus 1 untuk exercise pertama dalam daftar kosong.")
        #expect(unwrappedExercise.set == 3)
        #expect(unwrappedExercise.repOrTime == 15)
        #expect(unwrappedExercise.name == sampleMovement.name)
        #expect(viewModel.isError == false, "isError harus false saat sukses.")
        #expect(viewModel.errorMessage.isEmpty == true, "errorMessage harus kosong saat sukses.")
    }
    
    @Test("Buat exercise valid - Daftar ada, ID harus bertambah")
    func testCreateExercise_validInputs_existingList() throws {
        let sets = "2"
        let duration = "45"

        let newExercise = viewModel.createExercise(
            from: sampleMovement,
            setsString: sets,
            repOrTimeString: duration,
            currentExercises: sampleExistingExercises
        )
        
        let unwrappedExercise = try #require(newExercise, "Exercise seharusnya tidak nil.")
        
        #expect(unwrappedExercise.id == 3, "ID harus 3 (maks(2) + 1).")
        #expect(unwrappedExercise.set == 2)
        #expect(unwrappedExercise.repOrTime == 45)
        #expect(viewModel.isError == false)
    }
    

    @Test("Gagal buat exercise - Input set/rep kosong")
    func testCreateExercise_emptyInputs() {
        let sets = ""
        let reps = ""
        
        let newExercise = viewModel.createExercise(
            from: sampleMovement,
            setsString: sets,
            repOrTimeString: reps,
            currentExercises: sampleExistingExercises
        )
        
        #expect(newExercise == nil, "Exercise harus nil untuk input kosong.")
        #expect(viewModel.isError == true)
        #expect(viewModel.errorMessage == "Input tidak valid. Harap masukkan angka.")
    }
    
    @Test("Gagal buat exercise - Input set adalah 0")
    func testCreateExercise_zeroInputs() {
        let sets = "0"
        let reps = "10"
        
        let newExercise = viewModel.createExercise(
            from: sampleMovement,
            setsString: sets,
            repOrTimeString: reps,
            currentExercises: sampleExistingExercises
        )
        
        #expect(newExercise == nil, "Exercise harus nil jika set adalah 0.")
        #expect(viewModel.isError == true)
        #expect(viewModel.errorMessage == "Input harus lebih besar dari 0.", "Pesan error salah.")
    }
    
    @Test("Gagal buat exercise - Input rep/durasi negatif")
    func testCreateExercise_negativeInputs() {        
        let sets = "3"
        let reps = "-5"
        
        let newExercise = viewModel.createExercise(
            from: sampleMovement,
            setsString: sets,
            repOrTimeString: reps,
            currentExercises: sampleExistingExercises
        )
        
        #expect(newExercise == nil, "Exercise harus nil jika rep/time negatif.")
        #expect(viewModel.isError == true)
        #expect(viewModel.errorMessage == "Input harus lebih besar dari 0.", "Pesan error salah.")
    }
}

