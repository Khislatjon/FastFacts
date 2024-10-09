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
    
    init(title: String = "", body: String = "Type or Paste article...") {
        self.id = UUID().uuidString
        self.title = title
        self.body = body
    }
}
