//
//  PrimaryButton.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    private let color: Color
    
    init(color: Color) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .font(.system(size: 24, weight: .semibold))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color)
            .clipShape(.rect(cornerRadius: 16))
    }
}
