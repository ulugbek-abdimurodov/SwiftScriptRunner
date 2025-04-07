//
//  LineNumberRulerView.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 07/04/25.
//


import AppKit

class LineNumberRulerView: NSRulerView {
    weak var textView: NSTextView?

    init(textView: NSTextView) {
        self.textView = textView
        super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
        self.clientView = textView
        self.ruleThickness = 40
        self.needsDisplay = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = self.textView else { return }
        let layoutManager = textView.layoutManager!
        let textContainer = textView.textContainer!
        let string = textView.string as NSString
        let visibleRect = self.scrollView!.contentView.bounds

        let glyphRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

        let lineNumberAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedSystemFont(ofSize: 11, weight: .regular),
                .foregroundColor: NSColor.white
            ]

        var lineNumber = string.substring(to: characterRange.location).components(separatedBy: "\n").count
        var lineStart = characterRange.location

        while lineStart < characterRange.upperBound {
            var lineEnd = 0
            var contentEnd = 0
            string.getLineStart(nil, end: &lineEnd, contentsEnd: &contentEnd, for: NSRange(location: lineStart, length: 0))

            let glyphRange = layoutManager.glyphRange(forCharacterRange: NSRange(location: lineStart, length: 0), actualCharacterRange: nil)
            let rect = layoutManager.lineFragmentRect(forGlyphAt: glyphRange.location, effectiveRange: nil)

            let y = rect.minY + textView.textContainerInset.height
            let lineStr = "\(lineNumber)" as NSString
            let size = lineStr.size(withAttributes: lineNumberAttributes)
            lineStr.draw(at: NSPoint(x: self.ruleThickness - size.width - 4, y: y), withAttributes: lineNumberAttributes)

            lineStart = lineEnd
            lineNumber += 1
        }
    }
}
