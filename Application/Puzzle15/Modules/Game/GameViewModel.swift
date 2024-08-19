//
//  GameViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    enum Direction {
        case up, down, right, left
    }

    struct Item: Identifiable {
        let number: Int

        var id: Int { number }
    }

    @Published private(set) var steps = 0
    @Published private(set) var time = "00:00"
    @Published private(set) var field: [[Item]] = []
    @Published private(set) var isFinishMenuShown = false

    var fieldSize: Int {
        gameManager.fieldSize
    }

    var itemsFontSize: CGFloat {
        let fieldSize = gameManager.fieldSize
        return switch fieldSize {
        case 3: 40
        case 4: 32
        case 5...6: 24
        case 7...10: 18
        default: 10
        }
    }

    var itemSpacing: CGFloat {
        let fieldSize = gameManager.fieldSize
        return switch fieldSize {
        case 3...4: 12
        case 5...6: 4
        case 7...10: 2
        default: 0
        }
    }
    
    let appearance: Appearance

    private let gameManager: GameManagerProtocol

    init(gameManager: GameManagerProtocol, appearanceProvider: AppearanceProviderProtocol) {
        self.gameManager = gameManager
        self.appearance = appearanceProvider.current
    }

    func initialize() {
        subscribeOnGameUpdates()

        gameManager.restartGame()
    }

    func refreshGame() {
        gameManager.restartGame()
    }
    
    func pauseGame() {
        gameManager.pauseGame()
    }

    func makeTurn(to direction: Direction) {
        let turnDirection:TurnDirection = switch direction {
        case .up: .up
        case .down: .down
        case .left: .left
        case .right: .right
        }

        gameManager.makeTurn(to: turnDirection)
    }

    private func subscribeOnGameUpdates() {
        gameManager.fieldPublisher
            .receive(on: DispatchQueue.main)
            .map { field in
                field.map { row in row.map { Item(number: $0.number) } }
            }
            .assign(to: &$field)

        gameManager.stepsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$steps)

        gameManager.timePublisher
            .receive(on: DispatchQueue.main)
            .map { TimeFormatters.secondsToTimeString(seconds: $0) }
            .assign(to: &$time)

        gameManager.isPuzzleSolvedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFinishMenuShown)
    }
}

