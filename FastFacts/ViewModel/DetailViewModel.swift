//
//  DetailViewModel.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import Foundation

@Observable class DetailViewModel {
    let bert = BERT()
    var answer: String = ""
    
    func findAnswer(searchText: String, article: Article) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Use the BERT model to search for the answer.
            let answer = self.bert.findAnswer(for: searchText, in: article.body)
            print("Answer: \(answer)")

            // Update the UI on the main queue.
            DispatchQueue.main.async {
                self.answer = String(answer)
            }
        }
    }
}
