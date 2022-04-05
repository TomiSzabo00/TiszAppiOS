//
//  NeumorphicStyle.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 30..
//

import Foundation
import SwiftUI
import Combine

extension Color {
    static let offWhite = Color(red: 220 / 255, green: 221 / 255, blue: 225 / 255)
    static let highlight = Color.white
    static let shadow = Color.black.opacity(0.2)
    static let offBlack = Color(red: 107 / 255, green: 113 / 255, blue: 131 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButton<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.offWhite)
                    .overlay(
                        shape
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(shape.fill(LinearGradient(Color.black, Color.clear)))
                    )
                    .overlay(
                        shape
                            .stroke(Color.white, lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(shape.fill(LinearGradient(Color.clear, Color.black)))
                    )
                
            } else {
                shape
                    .fill(Color.offWhite)
                    .shadow(color: Color.shadow, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.highlight, radius: 10, x: -5, y: -5)
            }
        }
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .foregroundColor(.offBlack)
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .background(
                SimpleButton(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 20))
            )
    }
}

struct SimpleTextFieldWithIcon: View {
    var textField: TextField<Text>
    var imageName: String
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .foregroundColor(.offBlack)
            textField
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .foregroundColor(.offBlack)
        }
        .padding()
        .background(Color.offWhite)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 4)
                .blur(radius: 4)
                .offset(x: 2, y: 2)
                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.4), lineWidth: 8)
                .blur(radius: 4)
                .offset(x: -2, y: -2)
                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
        )
    }
}

struct SimpleSecureTextField: View {
    var secureFied: SecureField<Text>
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.offBlack)
            secureFied
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding()
        .background(Color.offWhite)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 4)
                .blur(radius: 4)
                .offset(x: 2, y: 2)
                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.4), lineWidth: 8)
                .blur(radius: 4)
                .offset(x: -2, y: -2)
                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
        )
    }
}

struct SimpleTextField: View {
    var textField: TextField<Text>
    
    var body: some View {
        textField
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .foregroundColor(.offBlack)
            .padding()
            .background(Color.offWhite)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.4), lineWidth: 8)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
            )
    }
}

struct SimpleNumberTextField: View {
    var text: Binding<String>
    
    var body: some View {
        TextField("0", text: text)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(Font.body.bold())
            .foregroundColor(.offBlack)
            .padding()
            .background(Color.offWhite)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.4), lineWidth: 8)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
            )
    }
}

struct SimpleText: View {
    var text: String
    var trailingPadding: CGFloat
    var maxLines: Int
    var maxWidth: CGFloat
    var isBold: Bool
    
    init(text: String, trailingPadding: CGFloat = 20, maxLines: Int = 1, maxWidth:CGFloat = 50, isBold: Bool = false) {
        self.text = text
        self.trailingPadding = trailingPadding
        self.maxLines = maxLines
        self.maxWidth = maxWidth
        self.isBold = isBold
    }
    
    var body: some View {
        Text(self.text)
            .fontWeight(isBold ? .bold : .regular)
            .font(.system(size: 16))
            .minimumScaleFactor(0.01)
            .lineLimit(self.maxLines)
            .foregroundColor(.offBlack)
            .frame(maxWidth: self.maxWidth, alignment: .center)
            .padding(5)
            .background(Color.offWhite)
            .cornerRadius(10)
            .shadow(color: Color.shadow, radius: 10, x: 5, y: 5)
            .shadow(color: Color.highlight, radius: 10, x: -5, y: -5)
    }
}
