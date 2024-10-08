//
//  ContentView.swift
//  FastFacts
//
//  Created by Khislatjon Valijonov on 08/10/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextFile: FileDocument {
    
    static var readableContentTypes: [UTType] = [UTType.plainText]
    
    var text = ""
    
    init(initialText: String = "") {
        self.text = initialText
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct ContentView: View {
    @State var document: TextFile = TextFile(initialText: "Jon")
    
    var body: some View {
        TextEditor(text: $document.text)
            .onAppear(perform: {
                print(document.text)
            })
    }
}

#Preview {
    ContentView(document: TextFile())
}
