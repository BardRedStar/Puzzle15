//
//  PauseMenuModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import SwiftUI

struct PauseMenuModuleBuilder {

    private let resolver: DependencyResolver
    private let didTapHome: () -> Void
    private let didTapResume: () -> Void

    init(
        resolver: DependencyResolver,
        didTapHome: @escaping () -> Void,
        didTapResume: @escaping () -> Void
    ) {
        self.resolver = resolver
        self.didTapHome = didTapHome
        self.didTapResume = didTapResume
    }

    func build() -> some View {

        let viewModel = PauseMenuViewModel(
            gameManager: resolver.resolve(),
            appearanceProvider: resolver.resolve()
        )

        return PauseMenuView(
            viewModel: viewModel,
            didTapHome: didTapHome,
            didTapResume: didTapResume
        )
    }
}
