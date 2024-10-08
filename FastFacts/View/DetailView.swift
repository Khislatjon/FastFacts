//
//  DetailView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI
import AVFoundation

struct DetailView: View {
    @State private var article: Article
    @State var question = ""
    @State var viewModel = DetailViewModel()
    @State private var showSheet = false
    let synthesizer = AVSpeechSynthesizer()
    
    init(article: Article) {
        self._article = State(initialValue: article)
    }
    
    var body: some View {
        AttributedTextEditor(text: $article.body, answer: $viewModel.answer, foundAnswer: { answer in
            let utterance = AVSpeechUtterance(string: answer)
            self.synthesizer.speak(utterance)
        })
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Ask")
                }
            }
        }
        .onDisappear {
            self.synthesizer.stopSpeaking(at: .word)
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
