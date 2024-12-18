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
    @State private var showQuestionSheet = false
    static let synthesizer = AVSpeechSynthesizer()
    
    init(article: Article) {
        self._article = State(initialValue: article)
    }
    
    var body: some View {
        AttributedTextEditor(text: $article.body, answer: $viewModel.answer, foundAnswer: { answer in
            let utterance = AVSpeechUtterance(string: answer)
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.voice = voice
            DetailView.synthesizer.speak(utterance)
        })
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showQuestionSheet.toggle()
                } label: {
                    Image(systemName: "questionmark.app")
                }.accessibilityAddTraits(.isButton)
                .accessibilityLabel("Ask a question")
                .accessibilityHint("Double tap to ask a question")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    HistoryView(article: $article)
                } label: {
                    Image(systemName: "clock")
                }.accessibilityAddTraits(.isLink)
                    .accessibilityLabel("See question and answer history")
                    .accessibilityHint("Double tap to see history of questions and answers")
            }
        }
        .sheet(isPresented: $showQuestionSheet) {
            QuestionView(question: $question)
                .onDisappear {
                    if !question.isEmpty {
                        viewModel.findAnswer(searchText: question, article: article)
                    }
                }
        }
        .onChange(of: viewModel.answer) { oldValue, newValue in
            if oldValue != newValue, !newValue.isEmpty {
                let history = History(question: self.question, answer: newValue)
                self.article.histories.append(history)
                self.question = ""
            }
        }
        .onDisappear {
            viewModel.answer = ""
        }
    }
}

#Preview {
    DetailView(article: Article())
}
