//
//  MainViewModel.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {

    @Published var backgroundColor: Color = .white
    @Published var foregroundColor: Color = .gray
    @Published var offset: CGFloat = 70
    @Published var symbols = ["apple.terminal", "globe", "apple.logo", "bolt", "iphone", "trophy", "moon.stars", "gamecontroller", "lightbulb.max.fill", "music.note", "car", "dollarsign", "steeringwheel", "film.stack", "face.smiling.inverse", "chevron.left.forwardslash.chevron.right", "chart.line.uptrend.xyaxis", "arkit", "hands.and.sparkles", "hand.thumbsup.fill", "hare", "cpu", "wifi", "mountain.2", "house.and.flag", "popcorn", "dice", "flag.checkered.2.crossed"]
    @Published var scale: CGFloat = 1
    @Published var size = CGSize(width: 3024, height: 1964)

    @Published var selectedSymbol: String?


    func addSymbol() {
        if let selectedSymbol {
            symbols.append(selectedSymbol)
        }
        self.selectedSymbol = nil
    }

    func deleteSymbol(at index: Int) {
        symbols.remove(at: index)
    }

}
