//
//  FinishMenuViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 16.08.2024.
//

import Foundation
import Combine

class FinishMenuViewModel: ObservableObject {

    private let gameManager: GameManagerProtocol
    let appearance: Appearance
    @Published private(set) var time: String
    @Published private(set) var steps: Int

    init(gameManager: GameManagerProtocol, appearanceProvider: AppearanceProviderProtocol) {
        self.gameManager = gameManager
        self.appearance = appearanceProvider.current

        self.time = TimeFormatters.secondsToTimeString(seconds: gameManager.timeSeconds)
        self.steps = gameManager.steps
    }

    func initialize() {
        subscribeOnGameUpdates()
    }

    func restartGame() {
        gameManager.restartGame()
    }

    private func subscribeOnGameUpdates() {
        gameManager.stepsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$steps)

        gameManager.timePublisher
            .receive(on: DispatchQueue.main)
            .map { TimeFormatters.secondsToTimeString(seconds: $0) }
            .assign(to: &$time)
    }

}
