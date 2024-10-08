//
//  ArticleView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI

struct ArticleView: View {
    
    @State private var showAlert = false
    @State private var article = Article()
    @State var viewModel = ArticleViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.articles) { article in
                NavigationLink {
                    DetailView(article: article)
                } label: {
                    Text(article.title)
                }
            }
            .onDelete { viewModel.articles.remove(atOffsets: $0) }
            .onMove { viewModel.articles.move(fromOffsets: $0, toOffset: $1) }
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
                }
            }
        }
        .alert("Add a new file", isPresented: $showAlert) {
            TextField("Title", text: $article.title)
            
            Button("Add") {
                guard !article.title.isEmpty else { return }
                viewModel.addArticle(article)
                article = Article()
            }
        } message: {
            Text("The app will save it for future use.")
        }
    }
}

#Preview {
    ArticleView()
}
