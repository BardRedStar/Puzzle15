//
//  SettingsViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published private(set) var fieldSizeOptionValue: SettingsOptionView.ValueType
    @Published private(set) var colorOptionValue: SettingsOptionView.ValueType

    private var fieldSize: Int {
        didSet {
            fieldSizeOptionValue = .number(fieldSize)
        }
    }

    private(set) var color: ThemeColor {
        didSet {
            colorOptionValue = .color(color.uiColor)
        }
    }

    private let gameRepository: GameRepositoryProtocol
    private let appearanceProvider: AppearanceProviderProtocol

    init(gameRepository: GameRepositoryProtocol, appearanceProvider: AppearanceProviderProtocol) {
        self.gameRepository = gameRepository
        self.appearanceProvider = appearanceProvider

        fieldSize = min(10, max(3, gameRepository.getFieldSize()))
        fieldSizeOptionValue = .number(fieldSize)
        color = appearanceProvider.current.primaryColor
        colorOptionValue = .color(color.uiColor)
    }

    func increaseFieldSize() {
        updateFieldSize(size: normalizeFieldSize(size: fieldSize + 1))
    }

    func decreaseFieldSize() {
        updateFieldSize(size: normalizeFieldSize(size: fieldSize - 1))
    }

    func changeColorToNext() {
        appearanceProvider.changeAppearanceToNext()
        color = appearanceProvider.current.primaryColor

        gameRepository.saveAppearance(key: appearanceProvider.current.key)
    }

    func changeColorToPrev() {
        appearanceProvider.changeAppearanceToPrev()
        color = appearanceProvider.current.primaryColor

        gameRepository.saveAppearance(key: appearanceProvider.current.key)
    }

    private func normalizeFieldSize(size: Int) -> Int {
        max(3, min(10, size))
    }

    private func updateFieldSize(size: Int) {
        gameRepository.setFieldSize(size: size)
        fieldSize = gameRepository.getFieldSize()
    }
}
