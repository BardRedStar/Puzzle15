//
//  GameModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct GameModuleBuilder {

    private let resolver: DependencyResolver
    private let didTapPause: () -> Void
    private let didFinishGame: () -> Void

    init(
        resolver: DependencyResolver,
        didTapPause: @escaping () -> Void,
        didFinishGame: @escaping () -> Void
    ) {
        self.resolver = resolver
        self.didTapPause = didTapPause
        self.didFinishGame = didFinishGame
    }

    func build() -> some View {
        let viewModel = GameViewModel(
            gameManager: resolver.resolve(),
            appearanceProvider: resolver.resolve()
        )

        return GameView(
            viewModel: viewModel,
            didTapPause: didTapPause, 
            didFinishGame: didFinishGame
        )
    }
}
