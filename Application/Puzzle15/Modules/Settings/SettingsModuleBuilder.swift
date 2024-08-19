//
//  SettingsModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct SettingsModuleBuilder {

    private let resolver: DependencyResolver
    private let didTapBack: () -> Void

    init(resolver: DependencyResolver, didTapBack: @escaping () -> Void) {
        self.resolver = resolver
        self.didTapBack = didTapBack
    }

    func build() -> some View {
        let viewModel = SettingsViewModel(
            gameRepository: resolver.resolve(),
            appearanceProvider: resolver.resolve()
        )

        return SettingsView(viewModel: viewModel, didTapBack: didTapBack)
    }
}
