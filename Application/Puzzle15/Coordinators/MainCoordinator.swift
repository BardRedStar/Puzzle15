//
//  MainCoordinator.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct MainCoordinator: View {

    enum Screen {
        case main
        case game
        case settings
    }

    @State private var currentScreen: Screen = .main
    @State private var isPauseScreenVisible: Bool = false
    @State private var isFinishScreenVisible: Bool = false

    private let resolver: DependencyResolver

    init(resolver: DependencyResolver) {
        self.resolver = resolver
    }

    var body: some View {
        viewForScreen(currentScreen)
    }

    @ViewBuilder
    private func viewForScreen(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            MainModuleBuilder(
                resolver: resolver,
                didTapPlay: { changeScreen(to: .game) },
                didTapSettings: { changeScreen(to: .settings) }
            )
            .build()
            .transition(.opacity)

        case .game:
            ZStack {
                GameModuleBuilder(
                    resolver: resolver,
                    didTapPause: {
                        setIsPauseVisible(true)
                    },
                    didFinishGame: {
                        setIsFinishVisible(true)
                    }
                )
                .build()
                .transition(.opacity)

                PauseMenuModuleBuilder(
                    resolver: resolver,
                    didTapHome: {
                        changeScreen(to: .main)
                        setIsPauseVisible(false)
                    },
                    didTapResume: {
                        setIsPauseVisible(false)
                    }
                )
                .build()
                .opacity(isPauseScreenVisible ? 1 : 0)
                .transition(.opacity)

                FinishMenuModuleBuilder(
                    resolver: resolver,
                    didTapHome: {
                        changeScreen(to: .main)
                        setIsFinishVisible(false)
                    },
                    didTapRestart: {
                        setIsFinishVisible(false)
                    }
                )
                .build()
                .opacity(isFinishScreenVisible ? 1 : 0)
                .transition(.opacity)
            }


        case .settings:
            SettingsModuleBuilder(
                resolver: resolver,
                didTapBack: { changeScreen(to: .main) }
            )
            .build()
            .transition(.opacity)
        }
    }

    private func changeScreen(to newScreen: Screen) {
        Task {
            try await Task.sleep(nanoseconds: 150_000_000)

            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    currentScreen = newScreen
                }
            }
        }
    }

    private func setIsPauseVisible(_ isVisible: Bool) {
        Task {
            try await Task.sleep(nanoseconds: 150_000_000)

            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    isPauseScreenVisible = isVisible
                }
            }
        }
    }

    private func setIsFinishVisible(_ isVisible: Bool) {
        Task {
            try await Task.sleep(nanoseconds: 150_000_000)

            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    isFinishScreenVisible = isVisible
                }
            }
        }
    }
}
