//
//  ScriptFixer.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 06/04/25.
//

import Foundation

struct ScriptFixer {
    
    /// Apply a set of auto-fix rules to the input script and return the corrected version.
    static func fix(script: String) -> String {
        var fixedScript = script
        
        // Fix common mistakes
        fixedScript = fixMissingSemicolons(in: fixedScript)
        fixedScript = fixMismatchedQuotes(in: fixedScript)
        fixedScript = fixUnbalancedBrackets(in: fixedScript)
        fixedScript = fixExtraSpaces(in: fixedScript)
        fixedScript = fixCommonTypos(in: fixedScript)
        
        return fixedScript
    }
    
    // MARK: - Auto-fix Rules
    
    /// Add semicolons at the end of lines where needed
    private static func fixMissingSemicolons(in script: String) -> String {
        let lines = script.components(separatedBy: .newlines)
        let fixedLines = lines.map { line -> String in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty || trimmed.hasSuffix(";") || trimmed.hasSuffix("{") || trimmed.hasSuffix("}") || trimmed.contains("//") {
                return line
            }
            return line + (line.last?.isLetter == true ? ";" : "")
        }
        return fixedLines.joined(separator: "\n")
    }
    
    /// Replace “ and ” with "
    private static func fixMismatchedQuotes(in script: String) -> String {
        return script
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "’", with: "'")
    }
    
    /// Balance brackets
    private static func fixUnbalancedBrackets(in script: String) -> String {
        let openCurly = script.filter { $0 == "{" }.count
        let closeCurly = script.filter { $0 == "}" }.count
        var fixedScript = script
        
        if openCurly > closeCurly {
            fixedScript += String(repeating: "\n}", count: openCurly - closeCurly)
        } else if closeCurly > openCurly {
            fixedScript = String(fixedScript.dropLast(closeCurly - openCurly))
        }
        
        return fixedScript
    }

    /// Replace multiple spaces or tabs with a single space
    private static func fixExtraSpaces(in script: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[ \t]{2,}", options: [])
        let range = NSRange(location: 0, length: script.utf16.count)
        return regex.stringByReplacingMatches(in: script, options: [], range: range, withTemplate: " ")
    }
    
    /// Fix common Swift typos
    private static func fixCommonTypos(in script: String) -> String {
        var fixed = script
        let typos = [
            "pritn": "print",
            "let ": "let ",
            "funciton": "function",
            "Strng": "String"
        ]
        for (wrong, correct) in typos {
            fixed = fixed.replacingOccurrences(of: wrong, with: correct)
        }
        return fixed
    }
}
