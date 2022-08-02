//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import CoreLocation

struct WorkoutView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    // Responsible for recording new workouts
    @StateObject var newWorkoutManager = NewWorkoutManager()
    // Responsible for managing workouts
    @StateObject var workoutsManager = WorkoutsManager()
    // Responsible for map settings
    @StateObject var mapManager = MapManager()
    
    // Map centre coordinate
    @State var centreCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        ZStack {
            MapView(centreCoordinate: $centreCoordinate)
                .ignoresSafeArea()
            FloatingMapButtons(centreCoordinate: $centreCoordinate)
            
            if newWorkoutManager.workoutState == .notStarted {
                WorkoutInfoBar()
                    .environmentObject(sessionService)
                    .animation(.none, value: workoutsManager.selectedWorkout)
                    .transition(.move(edge: .bottom))
            } else {
                NewWorkoutInfoBar()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.default, value: newWorkoutManager.workoutState)
        .environmentObject(newWorkoutManager)
        .environmentObject(workoutsManager)
        .environmentObject(mapManager)
        .preferredColorScheme(mapManager.mapType == .standard ? .none : .dark)
        .onAppear {
            newWorkoutManager.currTeam = sessionService.userDetails?.groupNumber ?? 0
        }
    }
}
