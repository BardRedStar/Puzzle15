//
//  SplashModuleBuilder.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct SplashModuleBuilder {

    private let resolver: DependencyResolver
    private let didLoad: () -> Void

    init(resolver: DependencyResolver, didLoad: @escaping () -> Void) {
        self.resolver = resolver
        self.didLoad = didLoad
    }

    func build() -> some View {
        let viewModel = SplashViewModel()
        return SplashView(viewModel: viewModel, didLoad: didLoad)
    }
}
