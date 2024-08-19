//
//  AppearanceProvider.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 15.08.2024.
//

import Foundation

protocol AppearanceProviderProtocol {
    var current: Appearance { get }

    func changeAppearanceToNext()
    func changeAppearanceToPrev()
}

class AppearanceProvider: AppearanceProviderProtocol {
    private var appearancesList: [Appearance] = [
        .init(key: "default", primaryColor: ThemeColor(uiColor: Colors.darkBlue)),
        .init(key: "red", primaryColor: ThemeColor(uiColor: Colors.darkRed)),
        .init(key: "green", primaryColor: ThemeColor(uiColor: Colors.darkGreen)),
        .init(key: "purple", primaryColor: ThemeColor(uiColor: Colors.darkPurple)),
        .init(key: "gray", primaryColor: ThemeColor(uiColor: Colors.darkGray)),
    ]

    private(set) var current: Appearance
    private var currentIndex: Int

    init(gameRepository: GameRepositoryProtocol) {
        let appearanceKey = gameRepository.getAppearance()

        self.currentIndex = appearancesList.firstIndex { appearanceKey == $0.key } ?? 0
        self.current = appearancesList[self.currentIndex]
    }

    func changeAppearanceToNext() {
        currentIndex = (currentIndex + 1) % appearancesList.count
        current = appearancesList[currentIndex]
    }

    func changeAppearanceToPrev() {
        currentIndex = currentIndex == 0 ? appearancesList.count - 1 : currentIndex - 1
        current = appearancesList[currentIndex]
    }
}
