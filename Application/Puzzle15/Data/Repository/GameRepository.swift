//
//  GameRepository.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation

protocol GameRepositoryProtocol {
    func getFieldSize() -> Int
    func setFieldSize(size: Int)

    func saveAppearance(key: String)
    func getAppearance() -> String
}

class GameRepository {

    private let storage: StorageServiceProtocol

    init(storage: StorageServiceProtocol) {
        self.storage = storage
    }
}

// MARK: - GameRepositoryProtocol

extension GameRepository: GameRepositoryProtocol {
    func getFieldSize() -> Int {
        storage.fieldSize
    }

    func setFieldSize(size: Int) {
        storage.fieldSize = size
    }

    func getAppearance() -> String {
        storage.appearance
    }

    func saveAppearance(key: String) {
        storage.appearance = key
    }
}
