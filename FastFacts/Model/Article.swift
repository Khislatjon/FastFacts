//
//  Article.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import Foundation
import SwiftData

@Model
class Article: Identifiable {
    let id: String
    var title: String
    var body: String
    var histories: [History]
    
    init(title: String = "", body: String = "Type or Paste article...", histories: [History] = []) {
        self.id = UUID().uuidString
        self.title = title
        self.body = body
        self.histories = histories
    }
}

