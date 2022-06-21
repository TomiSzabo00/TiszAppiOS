//
//  WordleViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 21..
//

import Foundation
import SwiftUI

enum GameState {
    case inProgress
    case win
    case lose
}

enum LetterState {
    case na
    case no
    case inWord
    case match
}

struct Letter: Identifiable, Hashable {
    let id = UUID()
    var letter: String
    var state: LetterState = .na
    
    init(_ letter : String = "") {
        self.letter = letter
    }
}

final class WordleViewModel: ObservableObject {
    
    @Published var keys : [String] = ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ő", "ú",
                                      "a", "s", "d", "f", "g", "h", "j", "k", "l", "é", "á", "ű",
                                      "í", "y", "x", "c", "v", "b", "n", "m", "ö", "ü", "ó",
                                      "<", "Beküld"]
    
    @Published var backgrounds: [Color] = [Color](repeating: .gray, count: 37)
    
    @Published var letters : [Letter] = [Letter](repeating: Letter(), count: 5*7)
    
    @Published var letterBGs: [Color] = [Color](repeating: .secondary, count: 5*7)
    
    private var words = [String]()
    
    @Published var solution = "tisza"
    
    private var sltn_copy = "tisza"
    
    private var currRow = 0
    
    @Published var noWord : Bool = false
    
    @Published var gameOver: Bool = false
    @Published var gameEnd: Bool = false
    @Published var gameState: GameState = .inProgress
    
    init() {
        getWords()
    }
    
    func getWords() {
        if let startWordsPath = Bundle.main.path(forResource: "magyar-szavak", ofType: "txt")
                {
                    if let startWords = try? String(contentsOfFile: startWordsPath)
                    {
                        let allWords = startWords.components(separatedBy: "\n")
                        for word in allWords {
                            if word.count == 5 {
                                self.words.append(word)
                            }
                        }
                    }
                    else
                    {
                        print("error")
                    }
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
            self.sltn_copy.remove(at: self.sltn_copy.firstIndex(of: Character(char))!)
            return .match
        }
        
        if self.sltn_copy.contains(char) {
            self.sltn_copy.remove(at: self.sltn_copy.firstIndex(of: Character(char))!)
            return .inWord
        }
        
        return .no
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
            return .secondary
        }
    }
    
    func updateRowBackgrounds() {
        for i in currRow*5..<(currRow+1)*5 {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.letterBGs[i] = self.updateBackground(state: self.letters[i].state)
            //})
            
        }
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
