//
//  PauseMenuView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 13.08.2024.
//

import Foundation
import SwiftUI

struct PauseMenuView: View {

    @StateObject private var viewModel: PauseMenuViewModel
    private let didTapHome: () -> Void
    private let didTapResume: () -> Void

    init(
        viewModel: PauseMenuViewModel,
        didTapHome: @escaping () -> Void,
        didTapResume: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didTapHome = didTapHome
        self.didTapResume = didTapResume
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    didTapResume()
                    viewModel.resumeGame()
                }

            Group {
                VStack(spacing: 24) {
                    Spacer()
                    
                    HStack(spacing: 24) {
                        Spacer()

                        Button {
                            didTapHome()
                        } label: {
                            Image(systemName: "house.fill")
                                .tint(.white)
                                .font(.system(size: 30, weight: .heavy))
                                .frame(width: 80, height: 80)
                                .background(viewModel.appearance.primaryColor.color)
                                .clipShape(.rect(cornerRadius: 8))
                        }

                        Button {
                            didTapResume()
                            viewModel.resumeGame()
                        } label: {
                            Image(systemName: "play.fill")
                                .tint(.white)
                                .font(.system(size: 30, weight: .heavy))
                                .frame(width: 80, height: 80)
                                .background(viewModel.appearance.primaryColor.color)
                                .clipShape(.rect(cornerRadius: 8))
                        }

                        Spacer()
                    }

                    Spacer()

                    SettingsOptionView(
                        title: "Field size",
                        value: viewModel.fieldSizeOptionValue,
                        arrowsColor: viewModel.appearance.primaryColor.color,
                        didTapLeftArrow: {
                            viewModel.decreaseFieldSize()
                        },
                        didTapRightArrow: {
                            viewModel.increaseFieldSize()
                        }
                    )

                    Spacer()
                }
                .padding(24)
            }
            .background(Color(uiColor: .tertiarySystemBackground))
            .clipShape(.rect(cornerRadius: 16))
            .padding(24)
            .aspectRatio(contentMode: .fit)
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.initialize()
        }
    }
}
