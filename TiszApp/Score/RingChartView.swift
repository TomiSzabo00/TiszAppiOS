//
//  RingChartView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 17..
//

import SwiftUI

struct RingChartView: View {
    
    @ObservedObject var handler: ScoresHandlerImpl
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ZStack {
                RingChart(name: "1", progress: $handler.sum1, dimension: UIScreen.main.bounds.width-100, trim: 0.94, rotate: 101)
                RingChart(name: "2", progress: $handler.sum2, dimension: UIScreen.main.bounds.width-150, trim: 0.925, rotate: 103.5)
                RingChart(name: "3", progress: $handler.sum3, dimension: UIScreen.main.bounds.width-200, trim: 0.905, rotate: 107)
                RingChart(name: "4", progress: $handler.sum4, dimension: UIScreen.main.bounds.width-250, trim: 0.87, rotate: 113)
            }
            
//            Rectangle()
//                .frame(maxWidth: 30, maxHeight: UIScreen.main.bounds.height, alignment: .center)
//                .background(Color.white)
        }
    }
}

struct RingChartView_Previews: PreviewProvider {
    static var previews: some View {
        RingChartView(handler: ScoresHandlerImpl())
    }
}
