//
//  GameManager.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import Combine

protocol GameManagerProtocol: GameControllerProtocol, TimerControllerProtocol {
    var timeSeconds: Int { get }
    var timePublisher: AnyPublisher<Int, Never> { get }

    var steps: Int { get }
    var stepsPublisher: AnyPublisher<Int, Never> { get }

    var fieldPublisher: AnyPublisher<[[GameItem]], Never> { get }
    var isPuzzleSolvedPublisher: AnyPublisher<Bool, Never> { get }

    var fieldSize: Int { get }
    var fieldSizePublisher: AnyPublisher<Int, Never> { get }
}

protocol GameControllerProtocol {
    func restartGame()
    func pauseGame()
    func makeTurn(to direction: TurnDirection)
    func increaseFieldSize()
    func decreaseFieldSize()
}

protocol TimerControllerProtocol {
    func restartTimer()
    func stopTimer()
}

class GameManager: GameManagerProtocol {

    @Published private(set) var timeSeconds = 0
    var timePublisher: AnyPublisher<Int, Never> { $timeSeconds.eraseToAnyPublisher() }

    @Published private var field: [[GameItem]] = []
    var fieldPublisher: AnyPublisher<[[GameItem]], Never> { $field.eraseToAnyPublisher() }

    @Published private(set) var steps = 0
    var stepsPublisher: AnyPublisher<Int, Never> { $steps.eraseToAnyPublisher() }

    @Published private var isPuzzleSolved = false
    var isPuzzleSolvedPublisher: AnyPublisher<Bool, Never> { $isPuzzleSolved.eraseToAnyPublisher() }

    @Published private(set) var fieldSize: Int
    var fieldSizePublisher: AnyPublisher<Int, Never> { $fieldSize.eraseToAnyPublisher() }

    private var timer: Timer?
    private var spacerCoords: Coordinate = (0, 0)

    private let gameRepository: GameRepositoryProtocol

    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository

        fieldSize = gameRepository.getFieldSize()
    }
}

// MARK: - GameControllerProtocol

extension GameManager {
    /// r - row (0-indexed), c - column (0-indexed)
    typealias Coordinate = (r: Int, c: Int)

    func restartGame() {
        fieldSize = max(3, gameRepository.getFieldSize())
        field = makeDefaultField(fieldSize: fieldSize)
        spacerCoords = getSpacerCoordinates(in: field)
        timeSeconds = 0
        steps = 0
        isPuzzleSolved = false

        restartTimer()
    }

    func pauseGame() {
        stopTimer()
    }

    func increaseFieldSize() {
        fieldSize += 1
        gameRepository.setFieldSize(size: fieldSize)
        restartGame()
        pauseGame()
    }

    func decreaseFieldSize() {
        fieldSize -= 1
        gameRepository.setFieldSize(size: fieldSize)
        restartGame()
        pauseGame()
    }

    func makeTurn(to direction: TurnDirection) {
        switch direction {
        case .up: makeTurnUp()
        case .down: makeTurnDown()
        case .right: makeTurnRight()
        case .left: makeTurnLeft()
        }
    }

    private func makeTurnDown() {
        let switchingItemCoords = (spacerCoords.0 - 1, spacerCoords.1)

        if switchingItemCoords.0 < 0 { return }

        performStep(spacerCoords: spacerCoords, switchingItemCoords: switchingItemCoords)
    }

    private func makeTurnUp() {
        let switchingItemCoords = (spacerCoords.0 + 1, spacerCoords.1)

        if switchingItemCoords.0 >= fieldSize { return }

        performStep(spacerCoords: spacerCoords, switchingItemCoords: switchingItemCoords)
    }

    private func makeTurnLeft() {
        let switchingItemCoords = (spacerCoords.0, spacerCoords.1 + 1)

        if switchingItemCoords.1 >= fieldSize { return }

        performStep(spacerCoords: spacerCoords, switchingItemCoords: switchingItemCoords)
    }

    private func makeTurnRight() {
        let switchingItemCoords = (spacerCoords.0, spacerCoords.1 - 1)

        if switchingItemCoords.1 < 0 { return }

        performStep(spacerCoords: spacerCoords, switchingItemCoords: switchingItemCoords)
    }

    private func performStep(spacerCoords: Coordinate, switchingItemCoords: Coordinate) {
        var field = self.field
        field[spacerCoords.0][spacerCoords.1] = field[switchingItemCoords.0][switchingItemCoords.1]
        field[switchingItemCoords.0][switchingItemCoords.1] = GameItem(number: 0)
        self.field = field

        self.spacerCoords = switchingItemCoords
        self.steps += 1

        if isPuzzleSolved(field: field) {
            isPuzzleSolved = true
            pauseGame()
        }
    }

    private func getSpacerCoordinates(in field: [[GameItem]]) -> Coordinate {
        for (i, row) in field.enumerated() {
            for (j, item) in row.enumerated() {
                if item.number == 0 {
                    return (i, j)
                }
            }
        }

        return (0, 0)
    }

    private func makeDefaultField(fieldSize: Int) -> [[GameItem]] {
        var shuffledSequence: Array<GameItem> = (0..<(fieldSize * fieldSize)).map { GameItem(number: $0) }
        shuffledSequence.shuffle()

        var index = 0

        var field = Array<[GameItem]>()
        for _ in 0..<fieldSize {
            var row = Array<GameItem>()
            for _ in 0..<fieldSize {
                row.append(shuffledSequence[index])
                index += 1
            }
            field.append(row)
        }

        if !checkFieldSolvability(field: field) {
            makeFieldSolvable(field: &field)

            if isPuzzleSolved(field: field) {
                return makeDefaultField(fieldSize: fieldSize)
            }
        }

        return field
    }

    private func checkFieldSolvability(field: [[GameItem]]) -> Bool {
        var zeroCoordinate: Coordinate = (0, 0)
        var totalInversions = 0
        for row in 0..<field.count {
            for column in 0..<field[row].count {

                if field[row][column].number == 0 {
                    zeroCoordinate = Coordinate(row, column)
                    continue
                }

                if field[row][column].number == 1 {
                    continue
                }

                var inversionsCount = 0

                for i in row..<field.count {
                    for j in column+1..<field[i].count {
                        if field[i][j].number != 0, field[row][column].number > field[i][j].number {
                            inversionsCount += 1
                        }
                    }
                }
                totalInversions += inversionsCount
            }
        }

        if (field.count % 2 != 0) {
            return totalInversions % 2 == 0
        }

        let zeroPosition = (field.count - zeroCoordinate.r) * (field.count - zeroCoordinate.c - 1)

        if (totalInversions % 2 == 0) {
            return zeroPosition % 2 == 1
        }

        return zeroPosition % 2 == 0
    }

    private func makeFieldSolvable(field: inout [[GameItem]]) {
        let first = field[0][0].number == 0 ? Coordinate(1, 1) : Coordinate(0, 0)
        let second = field[0][1].number == 0 ? Coordinate(1, 0) : Coordinate(0, 1)

        let temp = field[first.r][first.c]
        field[first.r][first.c] = field[second.r][second.c]
        field[second.r][second.c] = temp
    }

    private func isPuzzleSolved(field: [[GameItem]]) -> Bool {
        if field[field.count-1][field.count-1].number != 0 {
            return false
        }

        var currentNumber = 1

        for i in 0..<field.count {
            for j in 0..<field[i].count {
                if i == field.count - 1, j == field.count - 1 {
                    continue
                }

                if field[i][j].number != currentNumber {
                    return false
                }

                currentNumber += 1
            }
        }

        return true
    }
}

// MARK: - TimerControllerProtocol

extension GameManager {
    func restartTimer() {
        if timer?.isValid == true {
            timer?.invalidate()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timeSeconds += 1
        }
    }

    func stopTimer() {
        if timer?.isValid == true {
            timer?.invalidate()
        }
    }
}


