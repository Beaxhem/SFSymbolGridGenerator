//
//  ContentView.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI
import AppKit

extension NSView {

    /// Get `NSImage` representation of the view.
    ///
    /// - Returns: `NSImage` of view

    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }
}

extension View {
    func snapshot() -> NSImage {
        let controller = NSHostingView(rootView: self)
        let view = controller

        let targetSize = controller.intrinsicContentSize
        view.bounds = CGRect(origin: .zero, size: targetSize)

        return view.image()
    }
}

struct ContentView: View {

    var body: some View {
        ZStack {
            Button {
                let canvas = RandomSFSymbolsBackground().frame(width: 1290, height: 2796)
                guard let cgImage = ImageRenderer(content: canvas).cgImage else { return }

                let image = NSImage(cgImage: cgImage, size: .init(width: 1290, height: 2796))
                guard let representation = image.tiffRepresentation else { return }
                let imageRepresentation = NSBitmapImageRep(data: representation)

                let imageData = imageRepresentation?.representation(using: .png, properties: [:])

                guard let url = showSavePanel() else { return }

                try? imageData?.write(to: url)
            } label: {
                Text("Save")
            }
            .keyboardShortcut("s", modifiers: .command)

            RandomSFSymbolsBackground()
        }
    }

    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"

        let response = savePanel.runModal()

        return response == .OK ? savePanel.url : nil
    }

}

struct RandomSFSymbolsBackground: View {

    let offset: CGFloat =  50
    let symbols: [String] = ["function", "doc.text", "rectangle.and.pencil.and.ellipsis", "globe", "bolt", "number", "textformat.123"]

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                var offsetY: CGFloat = 0
                var offsetX: CGFloat = 0
                var alternating = false
                var index = 0

                context.scaleBy(x: 5, y: 5)

                while offsetY < size.height {
                    while offsetX < size.width {
                        let symbolName = symbols[index]

                        let x = offsetX
                        let y = offsetY

                        let image = Image(systemName: symbolName)
                            .resizable()

                        var resolvedImage = context.resolve(image)
                        resolvedImage.shading = .color(.gray)

                        context.draw(resolvedImage, at: .init(x: x, y: y))
                        offsetX += offset
                        index = index + 1 == symbols.count ? 0 : index + 1
                    }
                    alternating.toggle()
                    offsetX = alternating ? offset / 2 : 0
                    offsetY += offset
                }
            }
            .background(Color.white)
        }
    }
}


#Preview {
    ContentView()
}
