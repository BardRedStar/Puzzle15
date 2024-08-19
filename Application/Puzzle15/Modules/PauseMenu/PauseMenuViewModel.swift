//
//  PauseMenuViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import Combine

class PauseMenuViewModel: ObservableObject {

    @Published private(set) var fieldSizeOptionValue: SettingsOptionView.ValueType = .number(0)
    private var fieldSize: Int = 0 {
        didSet {
            fieldSizeOptionValue = .number(fieldSize)
        }
    }

    private var subscription: AnyCancellable?

    private let gameManager: GameManagerProtocol
    let appearance: Appearance

    init(gameManager: GameManagerProtocol, appearanceProvider: AppearanceProviderProtocol) {
        self.gameManager = gameManager
        self.appearance = appearanceProvider.current

        fieldSize = gameManager.fieldSize
        fieldSizeOptionValue = .number(fieldSize)
    }

    func initialize() {
        subscribeOnGameUpdates()
    }

    func increaseFieldSize() {
        if fieldSize >= 10 {
            return
        }

        gameManager.increaseFieldSize()
    }

    func decreaseFieldSize() {
        if fieldSize <= 3 {
            return
        }

        gameManager.decreaseFieldSize()
    }

    func pauseGame() {
        gameManager.pauseGame()
    }

    func resumeGame() {
        gameManager.restartTimer()
    }

    private func subscribeOnGameUpdates() {
        subscription?.cancel()
        subscription = gameManager.fieldSizePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] size in
                self?.fieldSize = size
            }
    }
}
