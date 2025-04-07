//
//  ThemeManager.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 06/04/25.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @AppStorage("isDarkMode") var isDarkMode: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }

    func toggleTheme() {
        isDarkMode.toggle()
    }

    private init() {}
}
