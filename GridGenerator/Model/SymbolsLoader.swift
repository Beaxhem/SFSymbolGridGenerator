//
//  SymbolsLoader.swift
//  GridGenerator
//
//  Created by Illia Senchukov on 24.02.2024.
//

import Foundation

class SymbolLoader {

    public static func loadSymbolsFromSystem() -> [String] {
        guard let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String] else {
            return []
        }

        return Array(plistSymbols.keys)
    }

}
