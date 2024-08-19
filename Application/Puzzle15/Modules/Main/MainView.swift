//
//  MainView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct MainView: View {

    @StateObject private var viewModel: MainViewModel

    private let didTapPlay: () -> Void
    private let didTapSettings: () -> Void

    init(
        viewModel: MainViewModel,
        didTapPlay: @escaping () -> Void,
        didTapSettings: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didTapPlay = didTapPlay
        self.didTapSettings = didTapSettings
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("15")
                .font(.system(size: 40, weight: .bold))
            Text("Puzzle Game")
                .font(.system(size: 30, weight: .semibold))

            Spacer().frame(height: 100)

            createButton(text: "Start Game", action: { didTapPlay() })

            createButton(text: "Settings", action: { didTapSettings() })
        }
    }

    @ViewBuilder
    private func createButton(text: String, action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: {
                Text(text).frame(width: 150, height: 40)
            }
        )
        .buttonStyle(PrimaryButtonStyle(color: viewModel.appearance.primaryColor.color))
    }
}
