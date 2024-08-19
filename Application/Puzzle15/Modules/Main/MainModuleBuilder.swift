//
//  MainModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct MainModuleBuilder {
    private let resolver: DependencyResolver
    private let didTapPlay: () -> Void
    private let didTapSettings: () -> Void

    init(
        resolver: DependencyResolver,
        didTapPlay: @escaping () -> Void,
        didTapSettings: @escaping () -> Void
    ) {
        self.resolver = resolver
        self.didTapPlay = didTapPlay
        self.didTapSettings = didTapSettings
    }

    func build() -> some View {
        let viewModel = MainViewModel(appearanceProvider: resolver.resolve())

        return MainView(
            viewModel: viewModel,
            didTapPlay: didTapPlay,
            didTapSettings: didTapSettings
        )
    }
}
