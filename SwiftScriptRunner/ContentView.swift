//
//  ContentView.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 05/04/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("selectedTheme") private var selectedTheme: String = "Dark"
    @State private var script: String = "print(\"Hello, World!\")"
    @State private var output: String = ""
    @State private var isRunning: Bool = false
    @State private var exitCode: Int32? = nil
    @State private var showSavePanel = false
    @State private var showOpenPanel = false
    @State private var scriptText: String = ""
    @State private var outputText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Material.bar)
            
            Divider()
            
            HStack(spacing: 0) {
                // Editor Section (70% width)
                editorPane
                    .frame(minWidth: 400, idealWidth: .infinity, maxWidth: .infinity)
                
                // Output Section (30% width)
                outputPane
                    .frame(minWidth: 200, idealWidth: 300, maxWidth: 300)
            }
            .frame(minHeight: 400)
            
            Divider()
            
            controlBar
                .padding()
        }
        .background(themeBackground)
        .preferredColorScheme(selectedTheme == "Dark" ? .dark : .light)
    }

    // MARK: - Header
    var header: some View {
        HStack {
            Spacer()
            
            Text("Swift Script Runner")
                .font(.largeTitle).bold()

            Spacer()

            Picker("Theme", selection: $selectedTheme) {
                Text("Dark").tag("Dark")
                Text("Light").tag("Light")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 160)
        }
        .padding(.horizontal)
    }

    // MARK: - Editor
    var editorPane: some View {
        VStack(alignment: .leading) {
            Text("Your code")
                .font(.headline)
                .padding(.leading, 48)
                .foregroundColor(.white)
            
            CodeEditor(text: $script)
                .frame(minHeight: 300)
        }
        .padding(8)
    }
    // MARK: - Output
    var outputPane: some View {
        VStack(alignment: .leading) {
            Text("Output")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView {
                Text(output)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
        }
        .padding()
    }
    // MARK: - Bottom Control Bar
    var controlBar: some View {
        HStack(spacing: 12) {
            Button(action: runScript) {
                HStack {
                                Image(systemName: "play.fill")
                                Text("Run")
                            }
                            .frame(minWidth: 80)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isRunning ? Color.gray : Color.blue)
                            }
                            .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .disabled(isRunning)

            Button(action: saveScript) {
                Label("Save", systemImage: "square.and.arrow.down")
            }

            Button(action: openScript) {
                Label("Load", systemImage: "folder")
            }

            Spacer()

            Text(isRunning ? "Running..." : "Idle")
                .foregroundColor(.secondary)

            if let code = exitCode {
                Text("Exit Code: \(code)")
                    .foregroundColor(code == 0 ? .green : .red)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Run Script
    private func runScript() {
        isRunning = true
        output = ""
        exitCode = nil

        ScriptExecutor.run(script: script) { line in
            output += line + "\n"
        } onComplete: { code in
            isRunning = false
            exitCode = code
        }
    }

    // MARK: - Save Script
    private func saveScript() {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["swift"]
        panel.nameFieldStringValue = "MyScript.swift"
        if panel.runModal() == .OK, let url = panel.url {
            try? script.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - Load Script
    private func openScript() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["swift"]
        if panel.runModal() == .OK, let url = panel.url {
            if let loadedScript = try? String(contentsOf: url) {
                script = loadedScript
            }
        }
    }

    // MARK: - Theming
    private var themeBackground: Color {
        selectedTheme == "Dark" ? Color.black.opacity(0.03) : Color.white
    }
}

#Preview {
    ContentView()
}
