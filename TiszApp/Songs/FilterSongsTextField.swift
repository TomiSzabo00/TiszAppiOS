//
//  FilterSongsTextField.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 13..
//

import SwiftUI

/// TextField capable of making predictions based on provided predictable values
struct FilterSongsTextField: View {
    
    /// All possible predictable values. Can be only one.
    @Binding var predictableValues: Array<String>
    
    @Binding var predictableValues2: Array<String>
    
    /// This returns the values that are being predicted based on the predictable values
    @Binding var predictedValues: Array<String>
    
    /// Current input of the user in the TextField. This is Binded as perhaps there is the urge to alter this during live time. E.g. when a predicted value was selected and the input should be cleared
    @Binding var textFieldInput: String
    
    /// The time interval between predictions based on current input. Default is 0.1 second. I would not recommend setting this to low as it can be CPU heavy.
    @State var predictionInterval: Double?
    
    /// Placeholder in empty TextField
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
        
        HStack {
            TextField(self.textFieldTitle ?? "", text: self.$textFieldInput, onEditingChanged: { editing in self.realTimePrediction(status: editing)}, onCommit: { self.makePrediction()})
                .disableAutocorrection(true)
                .autocapitalization(.words)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        
    }
    
    /// Schedules prediction based on interval and only a if input is being made
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
    
    /// Makes prediciton based on current input
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


