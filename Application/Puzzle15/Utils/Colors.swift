//
//  Colors.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import SwiftUI

enum Colors {
    static let darkBlue = UIColor(red: 0.25, green: 0.25, blue: 0.4, alpha: 1)
    static let darkRed = UIColor(red: 0.412, green: 0.079, blue: 0.055, alpha: 1)
    static let darkGreen = UIColor(red: 0.069, green: 0.328, blue: 0.167, alpha: 1)
    static let darkPurple = UIColor(red: 0.367, green: 0.243, blue: 0.375, alpha: 1)
    static let darkGray = UIColor(red: 0.245, green: 0.245, blue: 0.245, alpha: 1)
}

struct ThemeColor {
    let uiColor: UIColor

    var color: Color {
        Color(uiColor: uiColor)
    }
}

struct Appearance {
    let key: String
    let primaryColor: ThemeColor
}
