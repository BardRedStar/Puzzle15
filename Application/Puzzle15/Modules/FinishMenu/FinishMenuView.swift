//
//  FinishMenuView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 16.08.2024.
//

import Foundation
import SwiftUI

struct FinishMenuView: View {

    @StateObject private var viewModel: FinishMenuViewModel
    private let didTapRestart: () -> Void
    private let didTapHome: () -> Void

    init(
        viewModel: FinishMenuViewModel,
        didTapRestart: @escaping () -> Void,
        didTapHome: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didTapRestart = didTapRestart
        self.didTapHome = didTapHome
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Group {
                VStack(spacing: 24) {
                    Spacer()

                    Text("Congratulations!")
                        .font(.system(size: 32, weight: .medium))

                    Text("You finished puzzle in")
                        .font(.system(size: 24, weight: .medium))

                    Text(viewModel.time)
                        .font(.system(size: 28, weight: .medium))

                    Text("\(viewModel.steps) steps")
                        .font(.system(size: 28, weight: .medium))

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
                            didTapRestart()
                            viewModel.restartGame()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .rotationEffect(.degrees(45))
                                .tint(.white)
                                .font(.system(size: 30, weight: .heavy))
                                .frame(width: 80, height: 80)
                                .background(viewModel.appearance.primaryColor.color)
                                .clipShape(.rect(cornerRadius: 8))
                        }

                        Spacer()
                    }

                    Spacer()
                }
                .padding(32)
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
