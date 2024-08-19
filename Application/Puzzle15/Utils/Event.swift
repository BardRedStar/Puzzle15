//
//  Event.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Combine
import Foundation

@propertyWrapper
struct Event<Value> {
    var wrappedValue: Value? {
        didSet {
            if let wrappedValue {
                subject.send(wrappedValue)
            }
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        return subject.eraseToAnyPublisher()
    }

    private var subject = PassthroughSubject<Value, Never>()

    init() {}
}

extension Event: Publisher {
    typealias Output = Value
    typealias Failure = Never

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Value == S.Input {
        subject.compactMap { $0 }.receive(subscriber: subscriber)
    }
}
