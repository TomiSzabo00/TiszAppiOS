//
//  PredictedTextTest.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 29..
//

import SwiftUI

struct PredictedTextTest: View {
    @State var textFieldInput: String = ""
    @State var predictableValues: Array<String> = ["Szabó Tamás", "Szabó Tamás István", "Tüskés Szabolcs", "Picsa"]
    @State var predictedValue: Array<String> = []
    
    @State var isGuessed: Bool = false
    
    @State var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Predictable Values: ").bold()
            
            HStack{
                ForEach(self.predictableValues, id: \.self){ value in
                    Text(value)
                }
            }
            
            PredictingTextField(predictableValues: self.$predictableValues, predictedValues: self.$predictedValue, textFieldInput: self.$textFieldInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
            
            ZStack {
                if self.predictedValue.count > 0 {
                    ScrollView {
                        ForEach(self.predictedValue.indices) { i in
                            VStack {
                                if i == 0 {
                                    Button(action: {
                                        self.isGuessed = true
                                        endTextEditing()
                                        self.textFieldInput = self.predictedValue[i]
                                    }, label: {
                                        Text(self.predictedValue[i])
                                    })
                                    .foregroundColor(Color.primary)
                                    .padding(.top)
                                } else {
                                    Button(action: {
                                        self.isGuessed = true
                                        endTextEditing()
                                        self.textFieldInput = self.predictedValue[i]
                                    }, label: {
                                        Text(self.predictedValue[i])
                                    })
                                    .foregroundColor(Color.primary)
                                }
                                
                                if i != self.predictedValue.count - 1 {
                                    Rectangle().fill(Color.primary).frame(width: 250, height: 1, alignment: .center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .frame(height: 200, alignment: .center)
                }
            }
            Spacer()
        }.padding()
    }
}

struct PredictedTextTest_Previews: PreviewProvider {
    static var previews: some View {
        PredictedTextTest()
    }
}
