import Foundation

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
