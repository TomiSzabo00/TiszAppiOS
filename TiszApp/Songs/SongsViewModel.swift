//
//  SongsViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 12..
//

import Foundation

final class SongsViewModel: ObservableObject {
    
    @Published var data: String = ""
    
    @Published var songs = [String]()
    @Published var songTitles = [String]()
    @Published var songLyrics = [String]()
    
    init() {
        self.getAllFiles()
        
        let offsets = songs.enumerated().sorted { $0.element < $1.element }.map { $0.offset }

        // Use map on the array of ordered offsets to order the other arrays
        let sorted_songs = offsets.map { songs[$0] }
        let sorted_titles = offsets.map { songTitles[$0] }
        let sorted_lyrics = offsets.map { songLyrics[$0] }
        
        self.songs = sorted_songs
        self.songTitles = sorted_titles
        self.songLyrics = sorted_lyrics
    }
    
    func load(file: String) -> String {
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch let error as NSError {
                print(error.localizedDescription)
                return ""
            }
        } else {
            print("File not found")
            return ""
        }
    }
    
    private func getAllFiles() {
        guard let filepath = Bundle.main.path(forResource: "BIKA", ofType: "txt") else { return }
        guard let index = filepath.lastIndex(of: "/") else { return }
        let afterEqualsTo = String(filepath.prefix(upTo: index).dropFirst())
        if let enumerator = FileManager.default.enumerator(atPath: afterEqualsTo) {
            let filePaths = enumerator.allObjects as? [String]
            let txtFilePaths = filePaths?.filter{$0.contains(".txt")} ?? .init()
            for txtFilePath in txtFilePaths{
                guard let index = txtFilePath.lastIndex(of: ".") else { continue }
                let afterEqualsTo = String(txtFilePath.prefix(upTo: index))
                guard afterEqualsTo != "magyar_szavak" else { continue }
                songs.append(afterEqualsTo)
                songTitles.append(afterEqualsTo.lowercased().capitalized)
                songLyrics.append(self.load(file: afterEqualsTo))
            }
        } else {
            print("szamok beolvasasa nem jo")
        }
    }
}
