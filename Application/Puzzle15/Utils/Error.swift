//
//  Error.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation

enum DBError: Error {
    case failedToSave

    var errorDescription: String {
        switch self {
        case .failedToSave: "Failed to save info to database"
        }
    }
}
