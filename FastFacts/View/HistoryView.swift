//
//  HistoryView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 16/10/2024.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var article: Article
    
    var body: some View {
        List {
            ForEach(getSortedHistory()) { history in
                VStack(alignment: .leading) {
                    Text(history.question).font(.headline)
                    Text(history.answer)
                }
            }
            .onDelete { indexes in
                for index in indexes {
                    article.histories.remove(at: index)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Histories")
        .navigationBarItems(trailing: EditButton())
    }
    
    func getSortedHistory() -> [History] {
        article.histories.sorted { $0.date > $1.date }
    }
}

#Preview {
    HistoryView(article: .constant(Article()))
}
