//
//  ArticleViewModel.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import Foundation

@Observable class ArticleViewModel {
    var articles: [Article] = [
        Article(title: "Test")
    ]
    
    func addArticle(_ article: Article) {
        articles.append(article)
    }
}
