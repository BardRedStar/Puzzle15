//
//  SettingsView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel: SettingsViewModel
    private let didTapBack: () -> Void

    init(viewModel: SettingsViewModel, didTapBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didTapBack = didTapBack
    }

    var body: some View {

        VStack {

            Spacer().frame(height: 100)

            Text("Settings")
                .font(.system(size: 30, weight: .semibold))
            
            Spacer().frame(height: 64)

            SettingsOptionView(
                title: "Field size",
                value: viewModel.fieldSizeOptionValue,
                arrowsColor: viewModel.color.color,
                didTapLeftArrow: {
                    viewModel.decreaseFieldSize()
                },
                didTapRightArrow: {
                    viewModel.increaseFieldSize()
                }
            )

            Spacer().frame(height: 32)

            SettingsOptionView(
                title: "Color",
                value: viewModel.colorOptionValue,
                arrowsColor: viewModel.color.color,
                didTapLeftArrow: {
                    viewModel.changeColorToPrev()
                },
                didTapRightArrow: {
                    viewModel.changeColorToPrev()
                }
            )

            Spacer().frame(height: 64)

            Button(action: {
                didTapBack()
            }, label: {
                Text("Go back").frame(width: 150, height: 40)
            })
            .buttonStyle(PrimaryButtonStyle(color: viewModel.color.color))

            Spacer()
        }
        .padding(24)
    }
}
