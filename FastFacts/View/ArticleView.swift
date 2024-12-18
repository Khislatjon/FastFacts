//
//  ArticleView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI
import SwiftData

struct ArticleView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var articles: [Article]
    @State private var showAlert = false
    @State private var newArTitle = ""
    @State var viewModel = ArticleViewModel()
    
    var body: some View {
        List {
            ForEach(articles) { article in
                NavigationLink {
                    DetailView(article: article)
                } label: {
                    Text(article.title)
                }
            }
            .onDelete { indexes in
                for index in indexes {
                    delete(articles[index])
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Documents")
        .navigationBarItems(leading: EditButton())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Add")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Add new article")
                        .accessibilityHint("Double tap to add a new article")
                }
            }
        }
        .alert("Add a new file", isPresented: $showAlert) {
            TextField("Title", text: $newArTitle)
            
            Button("Add") {
                guard !newArTitle.isEmpty else { return }
                let item = Article(title: newArTitle)
                modelContext.insert(item)
                newArTitle = ""
            }
            Button("Cancel") {
                showAlert = false
            }
        } message: {
            Text("The app will save it for future use.")
        }
    }
    
    private func delete(_ article: Article) {
        modelContext.delete(article)
    }
}

#Preview {
    ArticleView()
}
