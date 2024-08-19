//
//  DependencyContainer.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation

protocol DependencyContainer: DependencyResolver {
    func register<T>(type: T.Type, name: String, provider: (DependencyResolver) -> T)
}

extension DependencyContainer {
    func register<T>(type: T.Type, name: String = String(describing: T.self), provider: (DependencyResolver) -> T) {
        register(type: type, name: name, provider: provider)
    }
}

protocol DependencyResolver {
    func resolve<T>(of type: T.Type, name: String) -> T?
    func resolve<T>(of type: T.Type) -> T?
}

extension DependencyResolver {
    func resolve<T>() -> T {
        resolve(of: T.self)!
    }

    func resolve<T: ExpressibleByNilLiteral>() -> T? {
        resolve(of: T.self)
    }

    func resolve<T: ExpressibleByNilLiteral>(name: String) -> T? {
        resolve(of: T.self, name: name)
    }
}

class CommonDependencyContainer: DependencyResolver, DependencyContainer {
    private struct DependencyKey: Hashable {
        let key: String
        let typeName: String
    }

    private var dependencies: [DependencyKey: Any] = [:]

    // MARK: - DependencyContainer

    func register<T>(
        type: T.Type,
        name: String = String(describing: T.self),
        provider: (DependencyResolver) -> T
    ) {
        dependencies[DependencyKey(key: name, typeName: String(describing: T.self))] = provider(self)
    }

    // MARK: - DependencyResolver

    func resolve<T>(of type: T.Type, name: String) -> T? {
        dependencies[DependencyKey(key: name, typeName: String(describing: T.self))] as? T
    }

    func resolve<T>(of type: T.Type) -> T? {
        resolve(of: type, name: String(describing: T.self))
    }
}
