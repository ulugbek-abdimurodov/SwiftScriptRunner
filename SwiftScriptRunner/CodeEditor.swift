//
//  AppKitTextView.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 06/04/25.
//
//
//import SwiftUICore
//import SwiftUI
//
//struct CodeEditor: NSViewRepresentable {
//    @Binding var text: String
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeNSView(context: Context) -> NSScrollView {
//        let textView = NSTextView()
//        textView.isRichText = false
//        textView.isEditable = true
//        textView.isSelectable = true
//        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
//        textView.backgroundColor = .red
//        textView.textColor = .white
//        textView.delegate = context.coordinator
//
//        let scrollView = NSScrollView()
//        scrollView.hasVerticalScroller = true
//        scrollView.documentView = textView
//        scrollView.backgroundColor = .black
//
//        let lineNumberView = LineNumberRulerView(textView: textView)
//        scrollView.verticalRulerView = lineNumberView
//        scrollView.hasVerticalRuler = true
//        scrollView.rulersVisible = true
//
//        context.coordinator.textView = textView
//        context.coordinator.lineNumberView = lineNumberView
//
//        return scrollView
//    }
//    
//    func updateNSView(_ nsView: NSScrollView, context: Context) {
//        if let textView = nsView.documentView as? NSTextView {
//            if textView.string != text {
//                textView.string = text
//            }
//        }
//    }
//
//    class Coordinator: NSObject, NSTextViewDelegate {
//        var parent: CodeEditor
//        weak var textView: NSTextView?
//        weak var lineNumberView: LineNumberRulerView?
//
//        init(_ parent: CodeEditor) {
//            self.parent = parent
//        }
//
//        func textDidChange(_ notification: Notification) {
//            guard let textView = notification.object as? NSTextView else { return }
//            parent.text = textView.string
//            lineNumberView?.needsDisplay = true
//        }
//    }
//}

import SwiftUICore
import SwiftUI

struct CodeEditor: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.backgroundColor = .black  // Fixed background
        textView.textColor = .white
        textView.delegate = context.coordinator

        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView
        scrollView.backgroundColor = .black  // Matching background

        let lineNumberView = LineNumberRulerView(textView: textView)
        scrollView.verticalRulerView = lineNumberView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true

        context.coordinator.textView = textView
        context.coordinator.lineNumberView = lineNumberView

        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            if textView.string != text {
                textView.string = text
            }
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CodeEditor
        weak var textView: NSTextView?
        weak var lineNumberView: LineNumberRulerView?

        init(_ parent: CodeEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            lineNumberView?.needsDisplay = true
        }
    }
}
