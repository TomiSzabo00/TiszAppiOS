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

struct SimpleButton<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.background)
                    .overlay(
                        shape
                            .stroke(Color.shadow, lineWidth: 6)
                            .blur(radius: 4)
                            .offset(x: 3, y: 3)
                            .mask(shape.fill(LinearGradient(Color.black, Color.clear)))
                    )
                    .overlay(
                        shape
                            .stroke(Color.highlight, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: -1, y: -1)
                            .mask(shape.fill(LinearGradient(Color.clear, Color.black)))
                    )
                
            } else {
                shape
                    .fill(Color.background)
                    .shadow(color: Color.shadow, radius: 3, x: 3, y: 3)
                    .shadow(color: Color.highlight, radius: 3, x: -2, y: -2)
            }
        }
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15)
            .foregroundColor(Color.white)
            //.foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .background(
                //SimpleButton(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 20))
                LinearGradient(Color.gradientDark, Color.gradientLight)
            )
            .cornerRadius(10)
    }
}

struct SimpleTextFieldWithIcon: View {
    var textField: TextField<Text>
    var imageName: String
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            textField
                .disableAutocorrection(true)
                .autocapitalization(.none)
                //.foregroundColor(.foreground)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.shadow, lineWidth: 6)
//                .blur(radius: 4)
//                .offset(x: 3, y: 3)
//                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.shadow, lineWidth: 6)
//                .blur(radius: 4)
//                .offset(x: 2, y: 2)
//                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
//        )
    }
}

struct SimpleSecureTextField: View {
    var secureFied: SecureField<Text>
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            secureFied
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.shadow, lineWidth: 6)
//                .blur(radius: 4)
//                .offset(x: 3, y: 3)
//                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.shadow, lineWidth: 6)
//                .blur(radius: 4)
//                .offset(x: 2, y: 2)
//                .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
//        )
    }
}

struct SimpleTextField: View {
    var textField: TextField<Text>
    
    var body: some View {
        textField
            .disableAutocorrection(true)
            .autocapitalization(.none)
            //.foregroundColor(.foreground)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.shadow, lineWidth: 6)
//                    .blur(radius: 4)
//                    .offset(x: 3, y: 3)
//                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.shadow, lineWidth: 6)
//                    .blur(radius: 4)
//                    .offset(x: 2, y: 2)
//                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
//            )
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
            //.foregroundColor(.foreground)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.shadow, lineWidth: 6)
//                    .blur(radius: 4)
//                    .offset(x: 3, y: 3)
//                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.black, Color.clear)))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.shadow, lineWidth: 6)
//                    .blur(radius: 4)
//                    .offset(x: 2, y: 2)
//                    .mask(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(Color.clear, Color.black)))
//            )
    }
}

struct SimpleText: View {
    var text: String
    var padding: CGFloat
    var trailingPadding: CGFloat
    var maxLines: Int
    var maxWidth: CGFloat
    var isBold: Bool
    var isGradient: Bool
    var alignment: Alignment
    
    init(text: String, padding: CGFloat = 5, trailingPadding: CGFloat = 20, maxLines: Int = 1, maxWidth:CGFloat = 50, isBold: Bool = false, isGradient: Bool = false, alignment: Alignment = .center) {
        self.text = text
        self.padding = padding
        self.trailingPadding = trailingPadding
        self.maxLines = maxLines
        self.maxWidth = maxWidth
        self.isBold = isBold
        self.isGradient = isGradient
        self.alignment = alignment
    }
    
    var body: some View {
        Text(self.text)
            .fontWeight(isBold ? .bold : .regular)
            .font(.system(size: 16))
            .minimumScaleFactor(0.01)
            .lineLimit(self.maxLines)
            .frame(maxWidth: self.maxWidth, alignment: alignment)
            .padding(self.padding)
            .background(Color.background)
            .cornerRadius(10)
            .shadow(color: Color.shadow, radius: 2, x: 3, y: 3)
            .shadow(color: Color.highlight, radius: 2, x: -2, y: -2)
            .foregroundStyle(self.isGradient ? LinearGradient(Color.gradientDark, Color.gradientLight) : LinearGradient(Color.foreground, Color.foreground))
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
                .fill(Color(.systemBackground))
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3)
        case .gray:
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3)
        case .color:
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(.gradientDark, .gradientLight))
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3)
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
            .shadow(color: Color.shadow, radius: 2, x: 3, y: 3)
            .shadow(color: Color.highlight, radius: 2, x: -2, y: -2)
    }
}
