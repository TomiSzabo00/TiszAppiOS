//
//  HiddenWordleViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 26..
//

import Foundation
import SwiftUI
import Firebase

final class HiddenWordleViewModel: ObservableObject {
    var stage: Int
    
    @Published var keys : [String] = ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ő", "ú",
                                      "a", "s", "d", "f", "g", "h", "j", "k", "l", "é", "á", "ű",
                                      "í", "y", "x", "c", "v", "b", "n", "m", "ö", "ü", "ó",
                                      "<", "Beküld"]
    
    @Published var backgrounds: [Color] = [Color](repeating: Color("wordle_button"), count: 37)
    
    @Published var letters : [Letter] = [Letter](repeating: Letter(), count: 5*7)
    
    @Published var letterBGs: [Color] = [Color](repeating: .clear, count: 5*7)
    
    private var words = [String]()
    
    @Published var solution = ""
    
    private var sltn_copy = ""
    
    private var currRow = 0
    
    @Published var noWord : Bool = false
    
    @Published var gameOver: Bool = false
    @Published var gameEnd: Bool = false
    @Published var gameState: GameState = .inProgress

    private(set) var solutions = ["újabb", "lépés", "szőke", "tisza", "másik", "végén"]
    
    init(stage: Int) {
        self.stage = stage
        getSolution()
        getWords()
    }
    
    func nextStage() {
        self.stage += 1
        getSolution()
        
        self.backgrounds = [Color](repeating: Color("wordle_button"), count: 37)
        self.letters = [Letter](repeating: Letter(), count: 5*7)
        self.letterBGs = [Color](repeating: .clear, count: 5*7)
        self.currRow = 0
        self.noWord = false
        self.gameOver = false
        self.gameEnd = false
        self.gameState = .inProgress
    }
    
    func getSolution() {
        self.solution = self.solutions[self.stage-1]
        self.sltn_copy = self.solution
    }
    
    func getWords() {
        if let startWordsPath = Bundle.main.path(forResource: "magyar_szavak", ofType: "txt")
                {
                    if let startWords = try? String(contentsOfFile: startWordsPath)
                    {
                        self.words = startWords.components(separatedBy: "\r\n")
                        //self.words = allWords.map { $0.trimmingCharacters(in: .whitespaces) }
                        //print(self.words)
                    }
                    else
                    {
                        print("error")
                    }
                }
    }
    
    func checkGameEnd() {
        var word = ""
        let row = max(self.currRow-1, 0)
        
        for i in row*5..<(row+1)*5 {
            word += self.letters[i].letter
        }
        
        print("\(word) checked... is \(self.solution)")
        
        if word == self.solution {
            self.gameOver = true
        }
    }
    
    func nextButonPressed(_ text: String) {
        let index = self.letters.firstIndex(where: { $0.letter == "" })
        
        switch text {
            
            case "<":
                if let idx = index {
                    if idx > 0 && Int((idx-1) / 5) == currRow {
                        self.letters[idx-1].letter = ""
                    } else {
                        print("trying to delete from another row")
                        //do nothing
                    }
                } else {
                    print("wordle empty")
                    //do nothing, game board is empty
                }
                break
            
            case "Beküld":
                //submit
                if !self.letters[currRow*5..<(currRow+1)*5].contains(where: { $0.letter == "" }) {
                    
                    var word = ""
                    
                    for i in currRow*5..<(currRow+1)*5 {
                        word += self.letters[i].letter
                    }
                    
                    print("\(word) bekuldve")
                    
                    guard self.words.contains(word) else {
                        print("nincs ilyen magyar szo")
                        self.noWord = true
                        break
                    }
                    
                    for i in currRow*5..<(currRow+1)*5 {
                        self.letters[i].state = updateLetterState(char: self.letters[i].letter, index: i - currRow*5)
                    }
                    
                    updateRowBackgrounds()
                    
                    if(word == self.solution) {
                        self.gameState = .win
                        self.gameEnd = true
                        self.gameOver = true
                    }
                    
                    self.sltn_copy = self.solution
                    self.currRow += 1
                    
                    if self.currRow == 7 {
                        self.gameState = .lose
                        self.gameEnd = true
                        self.gameOver = true
                    }
                } else {
                    print("trying to submit a not full row")
                }
                break
            
            //every other letter pressed
            default:
                if let index = index {
                    if Int(index / 5) == currRow {
                        self.letters[index] = Letter(text)
                    } else {
                        print("trying to add letter to new row")
                    }
                } else {
                    print("wordle full")
                    //do nothing, game board is full
                }
                break
        }
    }
    
    func updateLetterState(char: String, index: Int) -> LetterState {
        
        guard char.count == 1 else {
            print("nem egy hosszu a karakter")
            return .na
        }
        
        if self.solution[index] == char {
            guard let firstindex = self.sltn_copy.firstIndex(of: Character(char)) else { return .no }
            self.sltn_copy.remove(at: firstindex)
            self.backgrounds[self.keys.firstIndex(of: char) ?? 0] = .green
            return .match
        }
        
        if self.sltn_copy.contains(char) {
            guard let firstindex = self.sltn_copy.firstIndex(of: Character(char)) else { return .no }
            self.sltn_copy.remove(at: firstindex)
            if self.backgrounds[self.keys.firstIndex(of: char) ?? 0] != .green {
                self.backgrounds[self.keys.firstIndex(of: char) ?? 0] = .yellow
            }
            return .inWord
        }
        
        self.backgrounds[self.keys.firstIndex(of: char) ?? 0] = .gray
        return .no
    }
    
    func getCurrRowCount() {
        let index = self.letters.firstIndex(where: { $0.letter == "" })
        if let idx = index {
            self.currRow = Int(idx/5)
        } else {
            self.currRow = 7
            self.gameOver = true
        }
    }
    
    func updateBackground(state: LetterState) -> Color {
        switch state {
        case .no:
            return .gray
        case .inWord:
            return .yellow
        case .match:
            return .green
        default:
            return .clear
        }
    }
    
    func updateAllRowBackgrounds() {
        for i in 0..<self.letters.count {
            self.letterBGs[i] = self.updateBackground(state: self.letters[i].state)
        }
    }
    
    func updateRowBackgrounds() {
        for i in currRow*5..<(currRow+1)*5 {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.letterBGs[i] = self.updateBackground(state: self.letters[i].state)
            //})
            
        }
    }
    
    func stateFromString(s: String) -> LetterState {
        switch s {
        case "no":
            return .no
        case "inWord":
            return .inWord
        case "match":
            return .match
        default:
            return .na
        }
        
    }
}
