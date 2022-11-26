//
//  StartButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct StartButton: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var mapManager: MapManager

    var body: some View {
        Button(action: {
            recordWorkout()
        }, label: {
            Label("Útvonal rögzítése", systemImage: "record.circle")
        })
        .padding()
        .buttonStyle(ElevatedButtonStyle())
        .alert(isPresented: $newWorkoutManager.showAlert) {
            Alert(
                title: Text("Hiba történt."),
                message: Text("Az alkalmazásnak szüksége van a helyzetedre. Kérlek engedélyezd a beállításoknál."),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
    
    func recordWorkout() {
        newWorkoutManager.startWorkout()
        if newWorkoutManager.workoutState == .running {
            mapManager.userTrackingMode = .followWithHeading
        }
    }
}
