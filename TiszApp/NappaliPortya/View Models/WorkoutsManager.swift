//
//  WorkoutsManager.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit
import HealthKit
import FirebaseDatabase

class WorkoutsManager: NSObject, ObservableObject {
    // MARK: - Workouts
    @Published var workouts: [Workout] = []
    @Published var selectedWorkout: Workout?
    @Published var selectedNum = 0
    @Published var finishedLoading: Bool = false
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Load Health Store Workouts
        loadHealthKitWorkouts()
    }
    
    // MARK: - Private functions
    // Load HealthKit workouts
    private func loadHealthKitWorkouts() {

        //TODO: load db into workouts
        Database.database().reference().child("nappali_porty_locs").observe(.childAdded) { snapshot in
            self.workouts.append(Workout(snapshot: snapshot))
        }

        self.finishedLoading = true
    }
    
    // MARK: - Selected Workout
    // Select the first filtered workout to highlight
    public func selectFirstWorkout() {
        selectedWorkout = workouts.first
    }
    
    // Highlight next workout
    public func nextWorkout() {
        if workouts.isEmpty {
            selectedWorkout = nil
        } else if selectedWorkout == nil {
            selectedWorkout = workouts.first
        } else {
            let index = workouts.firstIndex(of: selectedWorkout!)
            if index == nil {
                selectedWorkout = workouts.first
            } else {
                if index == workouts.count-1 {
                    selectedWorkout = workouts.first
                } else {
                    selectedWorkout = workouts[(index ?? 0) + 1]
                }
            }
        }
        selectedNum = selectedWorkout?.teamNUm ?? 0
    }
    
    // Highlight previous workout
    public func previousWorkout() {
        if workouts.isEmpty {
            selectedWorkout = nil
        } else if selectedWorkout == nil {
            selectedWorkout = workouts.first
        } else {
            let index = workouts.firstIndex(of: selectedWorkout!)
            if index == nil {
                selectedWorkout = workouts.first
            } else {
                if index == 0 {
                    selectedWorkout = workouts.last
                } else {
                    selectedWorkout = workouts[(index ?? 0) - 1]
                }
            }
        }
        selectedNum = selectedWorkout?.teamNUm ?? 0
    }

    func getAllPolylines() -> [MKPolyline] {
        workouts.map { workout in
            MKPolyline(coordinates: workout.routeLocations.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)}, count: workout.routeLocations.count)
        }
    }
}
