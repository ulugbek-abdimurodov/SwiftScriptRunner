//
//  AppKitTextView.swift
//  SwiftScriptRunner
//
//  Created by Ulugbek Abdimurodov on 06/04/25.
//

import Foundation
import SwiftUI

struct AppKitTextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var scrollOffset: CGPoint
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AppKitTextView
        var scrollObserver: NSKeyValueObservation?
        
        init(_ parent: AppKitTextView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
        
        func setupScrollTracking(for scrollView: NSScrollView) {
            scrollObserver = scrollView.contentView.observe(\.bounds) { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.parent.scrollOffset = scrollView.contentView.bounds.origin
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        textView.delegate = context.coordinator
        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.backgroundColor = .black
        textView.textColor = .white
        context.coordinator.setupScrollTracking(for: scrollView)
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            textView.string = text
        }
    }
}
