//
//  AppCoordinator.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct AppCoordinator: View {

    enum Screen {
        case splash
        case main
    }

    @State private var currentScreen: Screen = .splash

    private let resolver: DependencyResolver

    init(resolver: DependencyResolver) {
        self.resolver = resolver
    }

    var body: some View {
        switch currentScreen {
        case .main:
            MainCoordinator(resolver: resolver)
                .transition(.opacity)

        case .splash:
            SplashModuleBuilder(resolver: resolver) {
                changeScreen(to: .main)
            }
            .build()
            .transition(.opacity)
        }
    }

    private func changeScreen(to screen: Screen) {
        Task {
            try await Task.sleep(nanoseconds: 150_000_000)

            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    currentScreen = screen
                }
            }
        }
    }
}
