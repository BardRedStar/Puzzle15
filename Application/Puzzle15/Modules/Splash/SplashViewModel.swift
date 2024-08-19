//
//  SplashViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {

    @Event private(set) var dataLoadedEvent: Void?

    func loadData() {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                self.dataLoadedEvent = ()
            }
        }
    }
}
