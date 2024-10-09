//
//  FastFactsApp.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI
import SwiftData

@main
struct FastFactsApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ArticleView()
            }
        }.modelContainer(for: Article.self)
    }
}
