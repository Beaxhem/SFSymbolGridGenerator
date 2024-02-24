//
//  ContentView.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI
import AppKit

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

struct ContentView: View {

    @ObservedObject var viewModel = MainViewModel()

    var body: some View {
        HStack {
            RandomSFSymbolsBackground(scale: $viewModel.scale,
                                      offset: $viewModel.offset,
                                      symbols: $viewModel.symbols,
                                      backgroundColor: $viewModel.backgroundColor,
                                      foregroundColor: $viewModel.foregroundColor)

            settings
                .frame(width: 300)
        }
    }

    var settings: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Preferences")
                .font(.title)

            backgroundColorPicker

            foregroundColorPicker

            scaleSlider

            offsetSlider

            exportSizeSetting

            SelectedSymbolsView(viewModel: viewModel)

            exportButton
        }
        .padding(.vertical)
    }

}

private extension ContentView {

    var backgroundColorPicker: some View {
        ColorPicker("Background color", selection: $viewModel.backgroundColor)
    }

    var foregroundColorPicker: some View {
        ColorPicker("Foreground color", selection: $viewModel.foregroundColor)
    }

    var scaleSlider: some View {
        Slider(value: $viewModel.scale, in: 1...5) {
            Text("Scale: \(Double(viewModel.scale).formatted(.number.precision(.fractionLength(...3))))")
        }
    }

    var offsetSlider: some View {
        Slider(value: $viewModel.offset, in: 10...200) {
            Text("Offset: \(Int(viewModel.offset))")
        }
    }

    var exportSizeSetting: some View {
        LabeledContent {
            TextField("Width", text: .init(get: {
                "\(Int(viewModel.size.width))"
            }, set: {
                if let n = NumberFormatter().number(from: $0) {
                    viewModel.size.width = CGFloat(truncating: n)
                }
            }))

            TextField("Height", text: .init(get: {
                "\(Int(viewModel.size.height))"
            }, set: {
                if let n = NumberFormatter().number(from: $0) {
                    viewModel.size.height = CGFloat(truncating: n)
                }
            }))
        } label: {
            Text("Export size")
        }
    }

    var exportButton: some View {
        Button {
            Task { @MainActor in
                saveImage()
            }
        } label: {
            Text("Export")
        }
        .keyboardShortcut("s", modifiers: .command)
    }

}

private extension ContentView {

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

    @MainActor func saveImage() {
        let canvas = RandomSFSymbolsBackground(scale: $viewModel.scale,
                                               offset: $viewModel.offset,
                                               symbols: $viewModel.symbols,
                                               backgroundColor: $viewModel.backgroundColor,
                                               foregroundColor: $viewModel.foregroundColor)
            .frame(width: viewModel.size.width, height: viewModel.size.height)

        guard let cgImage = ImageRenderer(content: canvas).cgImage else { return }

        let image = NSImage(cgImage: cgImage, size: .init(width: viewModel.size.width, height: viewModel.size.height))
        guard let representation = image.tiffRepresentation else { return }
        let imageRepresentation = NSBitmapImageRep(data: representation)

        let imageData = imageRepresentation?.representation(using: .png, properties: [:])

        guard let url = showSavePanel() else { return }

        try? imageData?.write(to: url)
    }

}

#Preview {
    ContentView()
}
