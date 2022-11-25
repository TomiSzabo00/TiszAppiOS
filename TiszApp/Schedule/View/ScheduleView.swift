//
//  ScheduleView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 27..
//

import SwiftUI

struct ScheduleView: View {
    @StateObject private var vm = ScheduleViewModel()

    var body: some View {
        TabView {
            ForEach(vm.scheduleDays) { day in
                ScheduleDayView(day: day)
                    .navigationTitle(vm.getDayOfWeek(for: day.dayNum))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
        .onDisappear {
            UITableView.appearance().backgroundColor = .systemGroupedBackground
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
