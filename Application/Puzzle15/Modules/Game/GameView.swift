//
//  GameView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct GameView: View {

    @State private var columns: [GridItem] = []
    @State private var gridItems: [GameViewModel.Item] = []

    @StateObject var viewModel: GameViewModel
    var didTapPause: () -> Void
    var didFinishGame: () -> Void

    init(
        viewModel: GameViewModel,
        didTapPause: @escaping () -> Void,
        didFinishGame: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didTapPause = didTapPause
        self.didFinishGame = didFinishGame
    }

    var body: some View {
        VStack {
            makeHeaderView()

            Spacer()

            ZStack {
                LazyVGrid(columns: columns, spacing: viewModel.itemSpacing) {
                    ForEach(gridItems, id: \.id) { item in
                        makeItemView(for: item)
                    }
                }

                makeTurnGestureView()
            }

            Spacer().frame(height: 48)

            makeFooterView()

            Spacer()
        }
        .padding(32)
        .onAppear {
            viewModel.initialize()
        }
        .onReceive(viewModel.$field) { field in
            columns = Array(
                repeating: GridItem(.flexible(), spacing: viewModel.itemSpacing),
                count: viewModel.fieldSize
            )

            withAnimation(.easeOut(duration: 0.1)) {
                gridItems = field.flatMap { $0 }
            }
        }
        .onReceive(viewModel.$isFinishMenuShown) { isShown in
            if isShown {
                didFinishGame()
            }
        }
    }

    @ViewBuilder
    private func makeItemView(for item: GameViewModel.Item) -> some View {
        if item.number == 0 {
            Color.clear
        } else {
            ZStack {
                Rectangle()
                    .fill(viewModel.appearance.primaryColor.color)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 8))

                Text("\(item.number)")
                    .font(.system(size: viewModel.itemsFontSize, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    @ViewBuilder
    private func makeTurnGestureView() -> some View {
        Color.white
            .opacity(0.0001)
            .ignoresSafeArea()
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let dX = value.translation.width
                        let dY = value.translation.height

                        let direction: GameViewModel.Direction = if abs(dX) > abs(dY) {
                            dX < 0 ? .left : .right
                        } else {
                            dY < 0 ? .up : .down
                        }
                        viewModel.makeTurn(to: direction)
                    }
            )
    }

    @ViewBuilder
    private func makeHeaderView() -> some View {
        HStack {
            Spacer()

            Button(
                action: {
                    viewModel.refreshGame()
                },
                label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundStyle(viewModel.appearance.primaryColor.color)
                        .rotationEffect(.degrees(45))
                }
            )

            Spacer().frame(width: 24)

            Button(
                action: {
                    didTapPause()
                    viewModel.pauseGame()
                },
                label: {
                    Image(systemName: "pause")
                        .font(.system(size: 23, weight: .heavy))
                        .foregroundStyle(viewModel.appearance.primaryColor.color)
                }
            )
        }
    }

    @ViewBuilder
    private func makeFooterView() -> some View {
        VStack {
            Text(viewModel.time)
                .font(.system(size: 30, weight: .semibold))

            Spacer()
                .frame(height: 24)

            Text("\(viewModel.steps)")
                .font(.system(size: 25, weight: .medium))
        }
    }
}
