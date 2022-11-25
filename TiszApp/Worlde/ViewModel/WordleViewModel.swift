//
//  WordleViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 21..
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

final class WordleViewModel: ObservableObject {
    var sessionService: SessionServiceImpl!
    
    @Published var keys : [String] = ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ő", "ú",
                                      "a", "s", "d", "f", "g", "h", "j", "k", "l", "é", "á", "ű",
                                      "í", "y", "x", "c", "v", "b", "n", "m", "ö", "ü", "ó",
                                      "<", "Beküld"]
    
    @Published var backgrounds: [Color] = [Color](repeating: Color("wordle_button"), count: 37)
    
    @Published var letters = [Letter]()
    
    @Published var letterBGs: [Color] = [Color](repeating: .clear, count: 5*7)
    @Published var letterRotationss: [Double] = [Double](repeating: 0.0, count: 5*7)
    
    private var words = [String]()
    
    @Published var solution = ""
    
    private var sltn_copy = ""
    
    private var currRow = 0
    
    @Published var noWord : Bool = false
    
    @Published var gameOver: Bool = false
    @Published var gameEnd: Bool = false
    @Published var gameState: GameState = .inProgress
    
    @Published var canSeeHidden : Bool = false

    @Published var rotation = 0.0
    
    init() {
        for _ in 0..<5*7 {
            letters.append(Letter())
        }
        getSolution()
        getWords()
        loadGame()
        initHidden()
    }
    
    func initHidden() {
        Database.database().reference().child("wordle").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                var toggles = [Bool]()
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)
                    
                    if toggles.count <= self.sessionService.teamNum {
                        toggles.append(shouldBeBool)
                    }
                }
                
                if let canSee = toggles[safe: (self.sessionService.userDetails?.groupNumber ?? 1)-1] {
                    self.canSeeHidden = canSee
                } else {
                    self.canSeeHidden = false
                }
                
            }
        })
        
        Database.database().reference().child("wordle").observe(.childChanged, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                var toggles = [Bool]()
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)
                    
                    if toggles.count <= self.sessionService.teamNum {
                        toggles.append(shouldBeBool)
                    }
                }
                
                var canSee = false
                do {
                    canSee = toggles[(self.sessionService.userDetails?.groupNumber ?? 1)-1]
                }
                self.canSeeHidden = canSee
                
            }
        })
    }
    
    func getSolution() {
        Database.database().reference().child("wordle").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "solution" {
                let value = snapshot.value as? String
                if let sol = value {
                    self.solution = sol
                    self.sltn_copy = sol
                    //print("\(sol) loaded")
                    self.checkGameEnd()
                } else {
                    print("nincs megoldas")
                }
            }
        })
    }
    
    func saveGame() {
        var saveData = [[String : String]]()
        
        for letter in self.letters {
            let letterData = ["letter" : letter.letter,
                              "state" : letter.state.name] as [String : String]
            saveData.append(letterData)
        }
        
        Database.database().reference().child("wordle").child("saves").child(Auth.auth().currentUser?.uid ?? "unknown").setValue(saveData)
        
    }
    
    func loadGame() {
        Database.database().reference().child("wordle").child("saves").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == Auth.auth().currentUser?.uid ?? "" {
                let snapshotData = snapshot.value as? [[String : String]]
                if let dataList = snapshotData {
                    guard self.currRow == 0 else { return }
                    self.letters.removeAll()
                    for data in dataList {
                        let letter = data["letter"]
                        let state = data["state"]
                        var loadedLetter = Letter(letter ?? "-")
                        loadedLetter.state = self.stateFromString(s: state ?? "")
                        if loadedLetter.state == .inWord {
                            self.backgrounds[self.keys.firstIndex(of: loadedLetter.letter) ?? 0] = .yellow
                        }
                        if loadedLetter.state == .match {
                            self.backgrounds[self.keys.firstIndex(of: loadedLetter.letter) ?? 0] = .green
                        }
                        if loadedLetter.state == .no {
                            self.backgrounds[self.keys.firstIndex(of: loadedLetter.letter) ?? 0] = .gray
                        }
                        self.letters.append(loadedLetter)
                    }

                    self.getCurrRowCount()
                    self.updateAllRowBackgrounds()

                    print("loaded game")
                    self.checkGameEnd()
                } else {
                    print("loadin worlde failed")
                }
                
            }
        })
    }
    
    func getWords() {
        if let startWordsPath = Bundle.main.path(forResource: "magyar_szavak", ofType: "txt")
                {
                    if let startWords = try? String(contentsOfFile: startWordsPath)
                    {
                        self.words = startWords.components(separatedBy: "\r\n")
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
                    self.letters[letters.count - 1].letter = ""
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
                        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                            self.gameState = .win
                            self.gameEnd = true
                            self.gameOver = true
                        }
                    }
                    
                    self.sltn_copy = self.solution
                    self.currRow += 1
                    
                    if self.currRow == 7 {
                        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                            self.gameState = .lose
                            self.gameEnd = true
                            self.gameOver = true
                        }
                    }
                    saveGame()
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

        if self.backgrounds[self.keys.firstIndex(of: char) ?? 0] != .green && self.backgrounds[self.keys.firstIndex(of: char) ?? 0] != .yellow {
            self.backgrounds[self.keys.firstIndex(of: char) ?? 0] = .gray
        }

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
    
    func updateRowBackgrounds(_ row: Int? = nil) {
        var delay = 0.0
        if let row = row {
            for i in row*5..<(row+1)*5 {
                withAnimation(.linear(duration: 0.5).delay(delay)) {
                    letterRotationss[i] += 180
                }
                withAnimation(.linear(duration: 0.5).delay(delay+0.25)) {
                    self.letterBGs[i] = self.updateBackground(state: self.letters[i].state)
                }
                delay += 0.5
            }
        } else {
            for i in currRow*5..<(currRow+1)*5 {
                withAnimation(.linear(duration: 0.5).delay(delay)) {
                    letterRotationss[i] += 180
                }
                withAnimation(.linear(duration: 0.5).delay(delay+0.25)) {
                    self.letterBGs[i] = self.updateBackground(state: self.letters[i].state)
                }
                delay += 0.5
            }
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

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
