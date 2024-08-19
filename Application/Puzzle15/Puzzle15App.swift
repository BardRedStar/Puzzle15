//
//  Puzzle15App.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import SwiftUI
import SwiftData

@main
struct Puzzle15App: App {
    private let container = assembleDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()

                AppCoordinator(resolver: container)
            }
        }
    }
}


// MARK: - DI

extension Puzzle15App {
    private static func assembleDependencyContainer() -> DependencyContainer {
        let container = CommonDependencyContainer()

        container.register(type: StorageServiceProtocol.self) { _ in
            StorageService()
        }

        container.register(type: GameRepositoryProtocol.self) { r in
            GameRepository(storage: r.resolve())
        }

        container.register(type: GameManagerProtocol.self) { r in
            GameManager(gameRepository: r.resolve())
        }

        container.register(type: AppearanceProviderProtocol.self) { r in
            AppearanceProvider(gameRepository: r.resolve())
        }

        return container
    }
}
