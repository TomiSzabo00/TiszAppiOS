//
//  ScheduleViewModel.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 13..
//

import FirebaseDatabase
import Foundation

final class ScheduleViewModel: ObservableObject {
    @Published var scheduleDays = [ScheduleDay]()

    let days = ["Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat", "Vasárnap"]

    private var firstDay = "Hétfő"

    init() {
        getFirstDay()
        getDays()
    }

    func getDays() {
        let scheduleLink = "https://opensheet.elk.sh/10JPtOuuQAMpGmorEHFW_yU-M2M99AAhpZn09CRcGPK4/schedule"

        guard let urlSchedule = URL(string: scheduleLink) else {
            print("teamNum url not working")
            fatalError()
        }

        let scheduleJSONtask = URLSession.shared.dataTask(with: urlSchedule){
            data, response, error in

            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let scheduleData = try decoder.decode([ScheduleData].self, from: data)
                DispatchQueue.main.async {
                    for dayData in scheduleData {
                        self.scheduleDays.append(ScheduleDay(data: dayData))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        scheduleJSONtask.resume()
    }

    func getFirstDay() {
        Database.database().reference().child("firstDayOfWeek").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            let day = snapshot.value as? String ?? "Hétfő"

            DispatchQueue.main.async {
                self.firstDay = day
            }
        }
    }

    func getDayOfWeek(for i: Int) -> String {
        days.wrapAround(to: i, from: firstDay)
    }
}

extension Array where Element == String {
    func wrapAround(to index: Int, from startingValue: String) -> Iterator.Element {
        let newIndex = (index + (self.firstIndex(of: startingValue) ?? 0)) % self.count
        return self[newIndex]
    }
}
