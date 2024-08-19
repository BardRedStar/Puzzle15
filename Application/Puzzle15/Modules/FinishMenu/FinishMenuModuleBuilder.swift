//
//  FinishMenuModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 16.08.2024.
//

import Foundation
import SwiftUI

struct FinishMenuModuleBuilder {
    
    private let resolver: DependencyResolver
    private let didTapHome: () -> Void
    private let didTapRestart: () -> Void

    init(
        resolver: DependencyResolver,
        didTapHome: @escaping () -> Void,
        didTapRestart: @escaping () -> Void
    ) {
        self.resolver = resolver
        self.didTapHome = didTapHome
        self.didTapRestart = didTapRestart
    }

    func build() -> some View {

        let viewModel = FinishMenuViewModel(
            gameManager: resolver.resolve(),
            appearanceProvider: resolver.resolve()
        )

        return FinishMenuView(
            viewModel: viewModel,
            didTapRestart: didTapRestart,
            didTapHome: didTapHome
        )
    }
}
