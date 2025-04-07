//
//  SwiftScriptRunnerApp.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 05/04/25.
//

import SwiftUI

@main
struct SwiftScriptRunnerApp: App {
    @StateObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
        .commands {
            CommandMenu("Appearance") {
                Toggle(isOn: $themeManager.isDarkMode) {
                    Text("Dark Mode")
                }
            }
        }
    }
}
