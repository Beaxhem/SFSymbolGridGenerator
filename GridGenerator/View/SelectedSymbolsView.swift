//
//  SelectedSymbolsView.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

struct SelectedSymbolsView: View {

    @ObservedObject var viewModel: MainViewModel
    @State var selectedSymbolIdx: Int?

    @State var isSymbolPickerPresented = false

    var body: some View {
        ScrollView {
            selectedSymbols

            symbolPickerButton
        }
        .sheet(isPresented: $isSymbolPickerPresented) {
            SymbolsPicker(title: "Test", viewModel: viewModel)
        }
    }

}

private extension SelectedSymbolsView {

    var symbolPickerButton: some View {
        Button {
            isSymbolPickerPresented = true
        } label: {
            Text("Add symbol")
        }
    }

    var selectedSymbols: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 50))],
                  alignment: .leading,
                  spacing: 0) {
            ForEach(viewModel.symbols.indices, id: \.self) { i in
                symbol(index: i)
            }
            .padding(.top, 5)
        }
        .padding(.horizontal)
    }

    @ViewBuilder func symbol(index: Int) -> some View {
        let icon = viewModel.symbols[index]

        Button {
            selectedSymbolIdx = index
        } label: {
            SymbolIcon(icon: viewModel.symbols[index], selection: .constant(""))
                .frame(width: 45, height: 45)
                .overlay(alignment: .topTrailing) {
                    if selectedSymbolIdx == index {
                        Button {
                            viewModel.deleteSymbol(at: index)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .buttonStyle(.borderless)
                        .padding(5)
                        .background(Color.black)
                        .clipShape(.capsule)
                    }
                }
        }
        .buttonStyle(SymbolButtonStyle())
    }

}
