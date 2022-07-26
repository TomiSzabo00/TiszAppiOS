//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import CoreLocation

struct FloatingMapButtons: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Button(action: {
                        mapManager.updateMapType()
                    }, label: {
                        Image(systemName: mapManager.mapTypeImageName)
                            .frame(width: 48, height: 48)
                            .animation(.none, value: mapManager.mapTypeImageName)
                    })
                    
                    Divider()
                        .frame(width: 48)
                    
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                            .frame(width: 48, height: 48)
                            .animation(.none, value: mapManager.userTrackingModeImageName)
                    })
                }
                .font(.system(size: 24))
                .background(Blur())
                .cornerRadius(10)
                .compositingGroup()
                .shadow(color: Color(UIColor.systemFill), radius: 5)
                .padding(.trailing, 10)
                .padding(.top, 48)
            }
            Spacer()
        }
    }
}
