//
//  WorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct WorkoutInfoBar: View {
    @EnvironmentObject var sessionService: SessionServiceImpl

    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if sessionService.userDetails?.admin ?? false {
                    HStack(spacing: 0) {
                        Button(action: {
                            workoutsManager.previousWorkout()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 24))
                                .frame(width: 48, height: 48)
                        })

                        Spacer()
                        Text("\(workoutsManager.selectedNum). csapat")
                        Spacer()

                        Button(action: {
                            workoutsManager.nextWorkout()
                        }, label: {
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 24))
                                .frame(width: 48, height: 48)
                        })
                    }
                    .frame(height: 70)
                    .background(Blur())
                    .cornerRadius(10)
                    .compositingGroup()
                    .shadow(color: Color(UIColor.systemFill), radius: 5)
                    .padding(10)
                } else {
                    StartButton()
                }
            }
        }
    }
}
