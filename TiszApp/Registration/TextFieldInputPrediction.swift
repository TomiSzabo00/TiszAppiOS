//
//  ContentView.swift
//  StackOverflow
//
//  Created by Simon Löwe on 04.04.20.
//  Copyright © 2020 Simon Löwe. All rights reserved.
//

import SwiftUI

/// TextField capable of making predictions based on provided predictable values
struct PredictingTextField: View {
    
    /// All possible predictable values. Can be only one.
    @Binding var predictableValues: Array<String>
    
    /// This returns the values that are being predicted based on the predictable values
    @Binding var predictedValues: Array<String>
    
    /// Current input of the user in the TextField. This is Binded as perhaps there is the urge to alter this during live time. E.g. when a predicted value was selected and the input should be cleared
    @Binding var textFieldInput: String
    
    /// The time interval between predictions based on current input. Default is 0.1 second. I would not recommend setting this to low as it can be CPU heavy.
    @State var predictionInterval: Double?
    
    @State var green: Bool = false
    
    /// Placeholder in empty TextField
    var textFieldTitle: String?
    
    @State private var isBeingEdited: Bool = false
    
    init(predictableValues: Binding<Array<String>>, predictedValues: Binding<Array<String>>, textFieldInput: Binding<String>, textFieldTitle: String? = "", predictionInterval: Double? = 0.1){
        
        self._predictableValues = predictableValues
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
            if green == true {
                Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
            }
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
                self.green = false
                self.makePrediction()
                
                if self.isBeingEdited == false {
                    timer.invalidate()
                }
            }
        }
    }
    
    /// Capitalizes the first letter of a String
    private func capitalizeFirstLetter(smallString: String) -> String {
        return smallString.prefix(1).capitalized + smallString.dropFirst()
    }
    
    /// Makes prediciton based on current input
    private func makePrediction() {
        self.predictedValues = []
        if !self.textFieldInput.isEmpty{
            for value in self.predictableValues {
                if value.contains(self.textFieldInput) || value.contains(self.capitalizeFirstLetter(smallString: self.textFieldInput)){
                    if !self.predictedValues.contains(String(value)) {
                        self.predictedValues.append(String(value))
                    }
                }
            }
            for value in self.predictedValues {
                if value == self.textFieldInput {
                    predictedValues.removeAll()
                    self.green = true
                }
            }
        }
    }
}

