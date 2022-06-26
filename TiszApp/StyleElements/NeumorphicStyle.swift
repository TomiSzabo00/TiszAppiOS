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
    static let background = Color("background")
    static let highlight = Color("highlight")
    static let shadow = Color("shadow")
    static let foreground = Color("foreground")
    static let gradientDark = Color("gradientDark")
    static let gradientLight = Color("gradientLight")
    static let gradientEnd = Color("gradientEnd")
    
    static let text = Color("btn_text")
    static let btn = Color("btn_day")
    static let main = Color("btn_s_day")
    static let secondary = Color("secondary")
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

enum BackroundStyle {
    case normal
    case gray
    case color
}


struct SimpleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15)
            .foregroundColor(
                isEnabled ? Color.text : Color.white)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .background(
                isEnabled ? Color.btn : .gray)
            .cornerRadius(10)
            .offset(y: configuration.isPressed ? 6 : 0)
            .shadow(color: isEnabled ? Color.main : .shadow, radius: 0, x: 0, y: configuration.isPressed ? 0 : 6)
    }
}

struct SimpleTextFieldWithIcon: View {
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

struct SimpleSecureTextField: View {
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

struct SimpleNumberTextField: View {
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

struct SimpleText: View {
    var text: Text
    
    init(text: Text) {
        self.text = text
    }
    
    var body: some View {
        self.text
            .bold()
            .foregroundStyle(Color.text)
            .frame(width: 120)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.btn)
                .shadow(color: Color.main, radius: 0, x: 0, y: 3))
    }
}

struct SimpleRectangle: View {
    var width: CGFloat
    var height: CGFloat
    var bg: BackroundStyle
    
    init(width: CGFloat, height: CGFloat, bg: BackroundStyle = .normal) {
        self.width = width
        self.height = height
        self.bg = bg
    }
    
    var body: some View {
        switch self.bg {
        case .normal:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary)
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color.shadow.opacity(0.2), radius: 4, x: 1, y: 3)
        case .gray:
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .frame(width: self.width, height: self.height, alignment: .center)
        case .color:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.btn)
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color.main, radius: 0, x: 0, y: 6)
        }
    }
}

struct SimpleImage: View {
    var image: UIImage
    var width: CGFloat
    var height: CGFloat
    
    init(image: UIImage, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(maxWidth: self.width, maxHeight: self.height, alignment: .center)
    }
}

struct WordleButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.padding(10)
            .foregroundColor(Color.white)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .cornerRadius(3)
            .offset(y: configuration.isPressed ? 1 : 0)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: configuration.isPressed ? 0 : 1)
    }
}
