//
//  NeumorphicStyle.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 30..
//

import Foundation
import SwiftUI
import Combine

struct TextFieldWithIcon: View {
    var textField: TextField<Text>
    var imageName: String
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .foregroundStyle(Color.text)
            textField
                .disableAutocorrection(false)
                .autocapitalization(.sentences)
        }
        .padding()
        .background(Color.secondary)
        .cornerRadius(10)
    }
}

struct SecureTextField: View {
    var secureFied: SecureField<Text>
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundStyle(Color.text)
            secureFied
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding()
        .background(Color.secondary)
        .cornerRadius(10)
    }
}

struct SimpleTextField: View {
    var textField: TextField<Text>
    
    var body: some View {
        textField
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .background(Color.secondary)
            .cornerRadius(10)
    }
}

struct NumberTextField: View {
    var text: Binding<String>
    
    var body: some View {
        TextField("0", text: text)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(Font.body.bold())
            .padding()
            .background(Color.secondary)
            .cornerRadius(10)
    }
}
