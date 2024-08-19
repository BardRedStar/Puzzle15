//
//  MainViewModel.swift
//  Puzzle15
//
//  Created by Denis Kovalev on 12.08.2024.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {

    let appearance: Appearance

    init(appearanceProvider: AppearanceProviderProtocol) {
        self.appearance = appearanceProvider.current
    }
}
