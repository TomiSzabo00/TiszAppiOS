//
//  RingChart.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 17..
//

import SwiftUI

struct RingChart: View {
    
    var name: String
    @Binding var progress: Int
    @State var dimension: CGFloat
    
    //let trimPercentage: CGFloat = 0.94/290
    var trim: CGFloat
    let rotate: CGFloat //= 101/210
    
    let outerShadowEnd: CGFloat = 160/290
    let outerShadowStart: CGFloat = 0.5
    
    let innerShadowEnd: CGFloat = 0.5
    let innerShadowStart: CGFloat = 130/290
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.background, lineWidth: 20)
                .overlay(
                    Circle()
                        .trim(from: 0, to: trim/*dimension * trimPercentage*/)
                        .stroke(Color.shadow,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(rotate/*(500-dimension) * rotatePercentage)*/))
                        .mask(Circle().stroke(RadialGradient(gradient: Gradient(colors: [Color.clear, Color.black]), center: .center, startRadius: dimension * outerShadowStart, endRadius: dimension * outerShadowEnd), lineWidth: 20))
                )
                .overlay(
                    Circle()
                        .trim(from: 0, to: trim/*dimension * trimPercentage*/)
                        .stroke(Color.shadow,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(rotate/*(500-dimension) * rotatePercentage)*/))
                        .mask(Circle().stroke(RadialGradient(gradient: Gradient(colors: [Color.black, Color.clear]), center: .center, startRadius: dimension * innerShadowStart, endRadius: dimension * innerShadowEnd), lineWidth: 20))
                )
            Circle()
                .trim(from: 0, to: CGFloat(progress)/1500)
                .trim(from: 0, to: trim)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.gradientDark, Color.gradientLight, Color.gradientDark]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                ).rotationEffect(.degrees(rotate/*(500-dimension) * rotatePercentage)*/))
        }.frame(maxWidth: dimension, maxHeight: dimension, alignment: .center)
        
        Text(name)
            .offset(y: ((dimension)/2))
            .foregroundColor(Color.foreground)
            .onAppear {
                //print(dimension * trimPercentage)
            }
    }
}
