//
//  DetailView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI

struct DetailView: View {
    let article: Article
    @State private var showSheet = false
    
    var body: some View {
        Button("Ask a question sheet") {
            showSheet = true
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Ask")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            QuestionView()
        }
    }
}

#Preview {
    DetailView(article: Article())
}
