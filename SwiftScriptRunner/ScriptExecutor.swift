//
//  ScriptExecutor.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 05/04/25.
//

import Foundation

struct ScriptExecutor {
    
    static func run(script: String,
                    onOutput: @escaping (String) -> Void,
                    onComplete: @escaping (Int32) -> Void) {
        
        // Step 1: Write script to a temporary file
        let tempDirectory = FileManager.default.temporaryDirectory
        let scriptURL = tempDirectory.appendingPathComponent("tempScript.swift")
        
        do {
            try script.write(to: scriptURL, atomically: true, encoding: .utf8)
        } catch {
            onOutput("❌ Failed to write script: \(error.localizedDescription)")
            onComplete(-1)
            return
        }

        // Step 2: Set up the process to run the script
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", scriptURL.path]

        // Step 3: Set up stdout and stderr pipes
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        // Step 4: Handle output in real time
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8), !str.isEmpty {
                DispatchQueue.main.async {
                    onOutput(str.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8), !str.isEmpty {
                DispatchQueue.main.async {
                    onOutput("⚠️ \(str.trimmingCharacters(in: .whitespacesAndNewlines))")
                }
            }
        }

        // Step 5: Launch the script
        do {
            try process.run()
        } catch {
            onOutput("❌ Could not launch process: \(error.localizedDescription)")
            onComplete(-1)
            return
        }

        // Step 6: Wait for script to finish
        process.terminationHandler = { proc in
            outputPipe.fileHandleForReading.readabilityHandler = nil
            errorPipe.fileHandleForReading.readabilityHandler = nil
            DispatchQueue.main.async {
                onComplete(proc.terminationStatus)
            }
        }
    }
}
