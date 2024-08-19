//
//  SettingsOptionView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 15.08.2024.
//

import Foundation
import SwiftUI

struct SettingsOptionView: View {

    enum ValueType {
        case number(Int)
        case color(UIColor)
    }

    var title: String
    var value: ValueType
    var arrowsColor: Color
    let didTapLeftArrow: () -> Void
    let didTapRightArrow: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .minimumScaleFactor(0.01)

            Spacer()

            Button {
                didTapLeftArrow()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .heavy))
                    .tint(arrowsColor)
            }

            getValueView(value: value)

            Button {
                didTapRightArrow()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 28, weight: .heavy))
                    .tint(arrowsColor)
            }
        }
    }

    @ViewBuilder
    private func getValueView(value: ValueType) -> some View {
        switch value {
        case let .number(value):
            Text("\(value)")
                .font(.system(size: 24, weight: .medium))
                .frame(width: 28)

        case let .color(color):
            Color(uiColor: color)
                .frame(width: 28, height: 28)
        }
    }
}
