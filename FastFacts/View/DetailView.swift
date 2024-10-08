//
//  DetailView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI

struct DetailView: View {
    @State private var article: Article
    @State var question = ""
    @State var viewModel = DetailViewModel()
    @FocusState var isInputActive: Bool
    @State private var showSheet = false
    
    init(article: Article) {
        self._article = State(initialValue: article)
    }
    
    var body: some View {
        TextEditor(text: $article.body)
            .focused($isInputActive)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isInputActive = false
                    showSheet.toggle()
                } label: {
                    Text("Ask")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            QuestionView(question: $question)
                .onDisappear {
                    if !question.isEmpty {
                        viewModel.findAnswer(searchText: question, article: article)
                        question = ""
                    }
                }
        }
    }
}

#Preview {
    DetailView(article: Article())
}
