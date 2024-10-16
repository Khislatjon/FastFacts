//
//  History.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 16/10/2024.
//

import Foundation
import SwiftData

@Model
class History: Identifiable {
    let id: String
    let date: Date
    let question: String
    let answer: String
    
    init(question: String, answer: String) {
        self.id = UUID().uuidString
        self.date = Date()
        self.question = question
        self.answer = answer
    }
}
