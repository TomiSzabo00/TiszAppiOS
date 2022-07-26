//
//  NewWorkoutManager.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
//import HealthKit
import MapKit
import Combine
import CoreLocation
import FirebaseDatabase

class NewWorkoutManager: NSObject, ObservableObject {
    // MARK: - Properties
    // Publish the following:
    // - Elapsed seconds
    // - Total distance travelled
    // - Accumulated locations from previous segments
    // - New locations from current segment
    // - Workout State
    @Published var elapsedSeconds: Int = 0
    @Published var distance: Double = 0
    @Published var workoutState: WorkoutState = .notStarted
    @Published var formattedAccumulatedLocations: [[CLLocationCoordinate2D]] = []
    @Published var formattedNewLocations: [CLLocationCoordinate2D] = []
    @Published var showAlert: Bool = false

    var currTeam: Int!

    private var locationManager: CLLocationManager!
    
    // Cancellable holds the timer publisher
    private var cancellable: Cancellable?
    private var startDate: Date = Date()
    private var accumulatedTime: Int = 0
    private var newLocations: [CLLocation] = []
    
    // Display formatting
    var elapsedSecondsString: String {
        String(format: "%02d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)
    }
    var totalDistanceString: String {
        String(format: "%.2f km", distance / 1000)
    }
    var toggleStateImageName: String {
        if workoutState == .running {
            return "pause.fill"
        } else {
            return "play.fill"
        }
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Start tracking the user
        setupLocationManager()
    }
    
    // MARK: - Private Methods
    private func startTimer() {
        // When this segment started
        startDate = Date()
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.calculateElapsedTime()
            }
    }
    
    private func calculateElapsedTime() -> Int {
        // Time of this segment
        let segmentTime: Int = Int(Date().timeIntervalSince(startDate))
        // Total all segments' times
        return segmentTime + accumulatedTime
    }
    
    private func saveNewLocations() {
        formattedAccumulatedLocations.append(formattedNewLocations)
        saveToDatabase()
        // Empty the new locations
        newLocations = []
        formattedNewLocations = []
    }
    
    // Setup the location manager to be used
    private func setupLocationManager() {
        // Create the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Set accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = 100
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        
        // Start tracking the user
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Workout State Control
    public func startWorkout() {
        // Start the timer
        self.startTimer()
        
        // Setup location manager
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true

        // Workout started
        self.workoutState = .running
    }
    
    public func toggleWorkoutState() {
        // Toggle state button pressed
        if workoutState == .running {
            pauseWorkout()
        } else {
            resumeWorkout()
        }
    }
    
    public func pauseWorkout() {
        // Stop the timer
        cancellable?.cancel()
        // Save the elapsed time
        accumulatedTime = elapsedSeconds
        // Stop tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = false
        // Save the new locations
        saveNewLocations()
        
        // Workout
        workoutState = .paused
    }
    
    public func resumeWorkout() {
        // Start the timer
        startTimer()
        // Start tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Workout resumed
        workoutState = .running
    }
    
    public func endWorkout() {
        // Stop the timer
        cancellable?.cancel()
        // Stop tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = false
        // Save to db
        saveToDatabase()
        // Reset workout
        resetWorkout()
        // Workout ended
        workoutState = .notStarted
    }

    private func saveToDatabase() {
        let locs = formattedNewLocations.map { location in
            ["lat" : location.latitude,
             "long" : location.longitude] as [String: Any]
        }

        Database.database().reference().child("nappali_porty_locs").child(String(currTeam)).setValue(locs)
    }
    
    private func resetWorkout() {
        // Reset the properties
        elapsedSeconds = 0
        distance = 0
        accumulatedTime = 0
        newLocations = []
    }
    
    // MARK: - Map Helper Methods
    // Return the current workout polyline
    public func getCurrentWorkoutMultiPolyline() -> [MulticolourPolyline] {
        var polylines: [MulticolourPolyline] = []
        let polylineColour: UIColor = .systemIndigo
        
        let newPolyline = MulticolourPolyline(coordinates: formattedNewLocations, count: formattedNewLocations.count)
        newPolyline.colour = polylineColour
        polylines.append(newPolyline)
        
        for segmentRouteLocations in formattedAccumulatedLocations {
            let newPolyline = MulticolourPolyline(coordinates: segmentRouteLocations, count: segmentRouteLocations.count)
            newPolyline.colour = polylineColour
            polylines.append(newPolyline)
        }
        
        return polylines
    }
}

// MARK: - CLLocationManager Delegate
extension NewWorkoutManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only add locations during a workout session
        if workoutState != .running { return }

        // Format and add the locations to the new locations arrays
        for location in locations {
            // Get the distance from the previous location
            if let lastLocation = newLocations.last {
                let delta: Double = location.distance(from: lastLocation)
                distance += delta
            }
            
            // Format locations
            let formattedLocation = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            newLocations.append(location)
            formattedNewLocations.append(formattedLocation)
        }
    }
}
