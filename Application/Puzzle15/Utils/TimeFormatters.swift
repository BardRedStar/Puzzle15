//
//  TimeFormatters.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation

enum TimeFormatters {

    static let time24hFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()

    static func secondsToTimeString(seconds: Int) -> String {
        time24hFormatter.string(
            from: Date(timeIntervalSince1970: Double(seconds))
        )
    }
}
