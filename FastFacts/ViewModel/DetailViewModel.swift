//
//  DetailViewModel.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import Foundation

@Observable class DetailViewModel {
    let bert = BERT()
    
    func findAnswer(searchText: String, article: Article) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Use the BERT model to search for the answer.
            let answer = self.bert.findAnswer(for: searchText, in: article.body)
            print("Answer: \(answer)")

            // Update the UI on the main queue.
//            DispatchQueue.main.async {
//                if answer.base == detail.body, let textView = self.documentTextView {
//                    // Highlight the answer substring in the original text.
//                    let semiTextColor = UIColor(named: "Semi Text Color")!
//                    let helveticaNeue17 = UIFont(name: "HelveticaNeue", size: 17)!
//                    let bodyFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: helveticaNeue17)
//                    
//                    let mutableAttributedText = NSMutableAttributedString(string: detail.body,
//                                                                          attributes: [.foregroundColor: semiTextColor,
//                                                                                       .font: bodyFont])
//                    
//                    let location = answer.startIndex.utf16Offset(in: detail.body)
//                    let length = answer.endIndex.utf16Offset(in: detail.body) - location
//                    let answerRange = NSRange(location: location, length: length)
//                    let fullTextColor = UIColor(named: "Full Text Color")!
//                    
//                    mutableAttributedText.addAttributes([.foregroundColor: fullTextColor],
//                                                         range: answerRange)
//                    textView.attributedText = mutableAttributedText
//                }
//                textField.text = String(answer)
//                textField.placeholder = placeholder
//            }
        }
    }
}
