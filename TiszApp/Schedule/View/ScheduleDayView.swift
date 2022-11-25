//
//  ScheduleDayView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import SwiftUI

struct ScheduleDayView: View {
    var day: ScheduleDay

    var body: some View {
        Form {
            Section {
                Text(String(day.breakfast).capitalized)
            } header: {
                Label("Reggeli", systemImage: "cup.and.saucer.fill")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))

            Section {
                Text(String(day.beforenoonTask).capitalized)
            } header: {
                Label("Délelőtti program", systemImage: "sun.and.horizon.fill")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))

            Section {
                Text(String(day.lunch).capitalized)
            } header: {
                Label("Ebéd", systemImage: "fork.knife")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))

            Section {
                Text(String(day.afternoonTask).capitalized)
            } header: {
                Label("Délutáni porgram", systemImage: "sun.max.fill")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))

            Section {
                Text(String(day.dinner).capitalized)
            } header: {
                Label("Vacsora", systemImage: "takeoutbag.and.cup.and.straw.fill")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))

            Section {
                Text(String(day.nightTask).capitalized)
            } header: {
                Label("Esti program", systemImage: "cloud.moon.fill")
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))
        }
    }
}

struct ScheduleDayView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDayView(day: ScheduleDay(
            dayNum: 1,
            breakfast: "Reggeli",
            beforenoonTask: "Program 1",
            lunch: "Ebéd",
            afternoonTask: "Promgram 2",
            dinner: "Vacsora",
            nightTask: "Program 3",
            midnightTask: "")
        )
    }
}
