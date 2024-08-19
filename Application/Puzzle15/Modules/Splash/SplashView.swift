//
//  SplashView.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import SwiftUI

struct SplashView: View {

    @StateObject private var viewModel: SplashViewModel

    private let didLoad: () -> Void

    init(viewModel: SplashViewModel, didLoad: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.didLoad = didLoad
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("15")
                .font(.system(size: 40, weight: .bold))
            Text("Puzzle Game")
                .font(.system(size: 30, weight: .semibold))
        }
        .onAppear {
            viewModel.loadData()
        }
        .onReceive(viewModel.$dataLoadedEvent.receive(on: DispatchQueue.main)) {
            didLoad()
        }
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel(), didLoad: {})
}
