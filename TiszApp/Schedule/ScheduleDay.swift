//
//  ScheduleDay.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import FirebaseDatabase
import Foundation

struct ScheduleDay: Identifiable {
    let id = UUID()
    var dayNum: Int
    var breakfast: String
    var beforenoonTask: String
    var lunch: String
    var afternoonTask: String
    var dinner: String
    var nightTask: String
    var midnightTask: String

    init() {
        self.dayNum = 0
        self.breakfast = "kenyer"
        self.beforenoonTask = "sport"
        self.lunch = "moslek"
        self.afternoonTask = "gyumolcsjatek"
        self.dinner = "moslek kenyerrel"
        self.nightTask = "fele sem igaz"
        self.midnightTask = "ejjeli portya"
    }

    init(dayNum: Int, breakfast: String, beforenoonTask: String, lunch: String, afternoonTask: String, dinner: String, nightTask: String, midnightTask: String) {
        self.dayNum = dayNum
        self.breakfast = breakfast
        self.beforenoonTask = beforenoonTask
        self.lunch = lunch
        self.afternoonTask = afternoonTask
        self.dinner = dinner
        self.nightTask = nightTask
        self.midnightTask = midnightTask
    }

    init(data: ScheduleData) {
        self.dayNum = Int(data.Day) ?? 0
        self.breakfast = data.Breakfast
        self.beforenoonTask = data.BeforenoonTask
        self.lunch = data.Lunch
        self.afternoonTask = data.AfternoonTask
        self.dinner = data.Dinner
        self.nightTask = data.NightTask
        self.midnightTask = data.MidnightTask ?? ""
    }
}

struct ScheduleData: Codable {
    var Day: String
    var Breakfast: String
    var BeforenoonTask: String
    var Lunch: String
    var AfternoonTask: String
    var Dinner: String
    var NightTask: String
    var MidnightTask: String?
}
