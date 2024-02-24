//
//  SymbolIcon.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import SwiftUI

struct SymbolIcon: View {

    let icon: String
    @Binding var selection: String?

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 25))
            .animation(.linear, value: selection)
            .foregroundColor(self.selection == icon ? Color.accentColor : Color.primary)
    }

}

#Preview {
    SymbolIcon(icon: "beats.powerbeatspro", selection: .constant("star.bubble"))
}
