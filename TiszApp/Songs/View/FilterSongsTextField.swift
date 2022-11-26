//
//  FilterSongsTextField.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 13..
//

import SwiftUI

struct FilterSongsTextField: View {
    @Binding var predictableValues: Array<String>
    @Binding var predictableValues2: Array<String>
    @Binding var predictedValues: Array<String>
    @Binding var textFieldInput: String
    @State var predictionInterval: Double?

    var textFieldTitle: String?
    
    @State private var isBeingEdited: Bool = false
    
    init(titles: Binding<Array<String>>, lyrics: Binding<Array<String>>, predictedValues: Binding<Array<String>>, textFieldInput: Binding<String>, textFieldTitle: String? = "", predictionInterval: Double? = 0.1){
        
        self._predictableValues = titles
        self._predictableValues2 = lyrics
        self._predictedValues = predictedValues
        self._textFieldInput = textFieldInput
        
        self.textFieldTitle = textFieldTitle
        self.predictionInterval = predictionInterval
    }

    var body: some View {
        SimpleTextField(textField: TextField(self.textFieldTitle ?? "", text: self.$textFieldInput, onEditingChanged: { editing in self.realTimePrediction(status: editing)}, onCommit: { self.makePrediction()}))
            .disableAutocorrection(true)
            .autocapitalization(.words)
    }

    private func realTimePrediction(status: Bool) {
        self.isBeingEdited = status
        if status == true {
            Timer.scheduledTimer(withTimeInterval: self.predictionInterval ?? 1, repeats: true) { timer in
                self.makePrediction()
                
                if self.isBeingEdited == false {
                    timer.invalidate()
                }
            }
        }
    }

    private func makePrediction() {
        self.predictedValues = []
        if !self.textFieldInput.isEmpty{
            for value in self.predictableValues {
                if value.contains(self.textFieldInput) || value.contains(self.textFieldInput.lowercased()) || value.contains(self.textFieldInput.lowercased().capitalized) {
                    if !self.predictedValues.contains(String(value)) {
                        self.predictedValues.append(String(value))
                    }
                }
            }

            for value in self.predictableValues2 {
                if value.contains(self.textFieldInput) || value.contains(self.textFieldInput.lowercased()) || value.contains(self.textFieldInput.lowercased().capitalized) {
                    let foundTitle = self.predictableValues[self.predictableValues2.firstIndex(of: value) ?? 0]
                    if !self.predictedValues.contains(String(foundTitle)) {
                        self.predictedValues.append(String(foundTitle))
                    }
                }
            }
        }
    }
}


