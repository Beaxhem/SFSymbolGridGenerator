//
//  RandomSFSymbolsBackground.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

struct RandomSFSymbolsBackground: View {

    @Binding var scale: CGFloat
    @Binding var offset: CGFloat
    @Binding var symbols: [String]
    @Binding var backgroundColor: Color
    @Binding var foregroundColor: Color

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                var offsetY: CGFloat = 0
                var offsetX: CGFloat = 0
                var alternating = false
                var index = 0

                context.scaleBy(x: scale, y: scale)

                while offsetY < size.height {
                    while offsetX < size.width {
                        let symbolName = symbols.randomElement()!

                        let x = offsetX
                        let y = offsetY

                        let image = Image(systemName: symbolName)
                            .resizable()

                        var resolvedImage = context.resolve(image)
                        resolvedImage.shading = .color(foregroundColor)

                        context.draw(resolvedImage, at: .init(x: x, y: y))
                        offsetX += offset
                        index = index + 1 == symbols.count ? 0 : index + 1
                    }
                    alternating.toggle()
                    offsetX = alternating ? offset / 2 : 0
                    offsetY += offset
                }
            }
            .background(backgroundColor)
        }
    }
}
