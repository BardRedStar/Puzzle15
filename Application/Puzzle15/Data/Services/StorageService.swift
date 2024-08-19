//
//  StorageService.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation

protocol StorageServiceProtocol: AnyObject {
    var fieldSize: Int { get set }
    var recordSteps: Int? { get set }
    var recordTime: Int? { get set }
    var appearance: String { get set }
}

class StorageService {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: - StorageServiceProtocol

extension StorageService: StorageServiceProtocol {

    enum Keys {
        static let fieldSize = "field_size"
        static let recordSteps = "record_steps"
        static let recordTime = "record_time"
        static let appearance = "appearance"
    }

    var fieldSize: Int {
        get {
            get(key: Keys.fieldSize, of: Int.self) ?? 0
        }
        set {
            set(key: Keys.fieldSize, value: newValue)
        }
    }

    var recordTime: Int? {
        get {
            get(key: Keys.recordTime, of: Int.self)
        }
        set {
            set(key: Keys.recordTime, value: newValue)
        }
    }

    var recordSteps: Int? {
        get {
            get(key: Keys.recordSteps, of: Int.self)
        }
        set {
            set(key: Keys.recordSteps, value: newValue)
        }
    }

    var appearance: String {
        get {
            get(key: Keys.appearance, of: String.self) ?? "default"
        }
        set {
            set(key: Keys.appearance, value: newValue)
        }
    }

}

// MARK: - Utils

extension StorageService {

    func get<T: Decodable>(key: String, of type: T.Type) -> T? {
        guard let object = userDefaults.object(forKey: key) as? Data else { return nil }

        return try! decoder.decode(type, from: object)
    }

    func set<T: Encodable>(key: String, value: T?) {
        guard let value else {
            userDefaults.removeObject(forKey: key)
            return
        }

        let object = try! encoder.encode(value)

        userDefaults.setValue(object, forKey: key)
    }
}
