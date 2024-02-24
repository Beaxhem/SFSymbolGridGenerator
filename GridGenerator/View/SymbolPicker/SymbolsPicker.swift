//
//  SymbolsPicker.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

struct SymbolsPicker: View {

    let title: String
    let searchbarLabel: String = "Search..."

    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var isFirstTimeAppeared = false
    @State private var symbols: [String] = []

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, label: searchbarLabel)

            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                    ForEach(symbols.filter{searchText.isEmpty ? true : $0.contains(searchText.lowercased()) }, id: \.hash) { icon in

                        Button {
                            withAnimation {
                                viewModel.selectedSymbol = icon
                            }
                        } label: {
                            SymbolIcon(icon: icon, selection: $viewModel.selectedSymbol)
                                .frame(width: 50, height: 50)
                        }
                        .buttonStyle(SymbolButtonStyle())

                    }.padding(.top, 5)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        viewModel.selectedSymbol = ""
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.addSymbol()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                    }
                }
            }
            .padding(.vertical, 5)

        }
        .padding(.horizontal, 5)
        .onAppear {
            if(!isFirstTimeAppeared) {
                self.symbols = SymbolLoader.loadSymbolsFromSystem()
            }
        }
        .frame(width: 500, height: 500)
    }

    func test() {
        viewModel.addSymbol()
    }

}

struct SymbolButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.init(nsColor: .init(white: 0.1, alpha: 1)))
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
    }

}
