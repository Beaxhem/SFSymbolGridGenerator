//
//  SearchBar.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

struct SearchBar: View {

    @Binding var searchText: String
    let label: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(label, text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(nsColor: .init(white: 0.1, alpha: 1)))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""), label: "Search...")
}
