//
//  AttributedTextEditor.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI

struct AttributedTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var answer: String
    var foundAnswer: ((String) -> Void)?
    
    init(text: Binding<String>, answer: Binding<String>, foundAnswer: ((String) -> Void)?) {
        self._text = text
        self._answer = answer
        self.foundAnswer = foundAnswer
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "HelveticaNeue", size: 17)!
        textView.isEditable = true
        
        let attr = attributeText(text: text, answer: answer)
        textView.attributedText = attr.0
        if let range = attr.1 {
            textView.scrollRangeToVisible(range)
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let attr = attributeText(text: text, answer: answer)
        uiView.attributedText = attr.0
        if let range = attr.1 {
            uiView.scrollRangeToVisible(range)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AttributedTextEditor
        @Binding var text: String
        
        init(_ uiTextView: AttributedTextEditor, _ text: Binding<String>) {
            self.parent = uiTextView
            self._text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
    
    func attributeText(text: String, answer: String) -> (NSMutableAttributedString, NSRange?) {
        let helveticaNeue17 = UIFont(name: "HelveticaNeue", size: 17)!
        let bodyFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: helveticaNeue17)
        
        let mutableAttributedText = NSMutableAttributedString(string: text,
                                                              attributes: [.foregroundColor: UIColor.black,
                                                                           .font: bodyFont])
        
        guard !answer.isEmpty else { return (mutableAttributedText, nil) }
        
        let nsText: NSString = text as NSString
        let answerRange: NSRange = nsText.range(of: answer)
        mutableAttributedText.addAttributes([.backgroundColor: UIColor.systemOrange,
                                             .foregroundColor: UIColor.white], range: answerRange)
        
        self.foundAnswer?(answer)
        
        return (mutableAttributedText, answerRange)
    }
}
