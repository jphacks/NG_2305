//
//  FileSelectionView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/18.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileSelectionView: View {
    @State private var isDocumentPickerPresented: Bool = false
    @State private var files: [URL] = []
    
    private let fileManager = FileManager.default
    
    var body: some View {
        List {
            ForEach(files, id: \.self) { file in
                Text(file.lastPathComponent)
            }
            
            Button("ファイルを追加") {
                isDocumentPickerPresented.toggle()
            }
            .fileImporter(
                isPresented: $isDocumentPickerPresented,
                allowedContentTypes: [UTType.pdf],
                onCompletion: { result in
                    do {
                        let selectedFile = try result.get()
                        try savePDF(url: selectedFile)
                    } catch {
                        print(error)
                    }
                }
            )
        }
        .onAppear {
            fetchFiles()
        }
    }
    
    func savePDF(url: URL) throws {
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            _ = url.startAccessingSecurityScopedResource()
            try fileManager.copyItem(at: url, to: destinationURL)

            url.stopAccessingSecurityScopedResource()
        }
        
        fetchFiles()
    }
    
    func fetchFiles() {
        do {
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let directoryContents = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

                files = directoryContents
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    FileSelectionView()
}
