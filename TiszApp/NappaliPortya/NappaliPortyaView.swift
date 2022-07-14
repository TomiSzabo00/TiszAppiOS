//
//  NappaliPortyaView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 27..
//

import MapKit
import SwiftUI

struct NappaliPortyaView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl

    @StateObject private var vm = NappaliPortyaViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: Binding($vm.locationRegion) ?? $vm.tiszapuspokiFaluCoords, interactionModes: MapInteractionModes.all, showsUserLocation: true, userTrackingMode: $vm.trackingMode)
            .ignoresSafeArea()
            .onAppear {
                vm.sessionService = self.sessionService
                vm.checkIfLocationServicesIsEnabled()
            }
            .alert("Helymeghatározás hiba", isPresented: $vm.showAlert, actions: {}) {
                switch(vm.alertType) {
                case .disabled:
                    Text("A helymeghatározási beállítások le vannak tiltva. Kérlek engedélyezd őket. Beállítások > Adatvédelem > Helymeghatározás")
                case .denied:
                    Text("Az alkalmazásnak nem adtál engedélyt a helyzeted megtekintésére. Kérlek engedélyzed, a funkció használatához. Beállítások > Adatvédelem > Helymeghatározás")
                case .restricted:
                    Text("A helymeghatározás le van tiltva a telefonon, valószínűleg szülői felügyelet miatt. Kérlek engedélyeztesd a funkció használatához.")
                case .na:
                    Text("A helymeghatározás nem működik jelenleg. Próbáld meg később.")
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        vm.centerMap()
                    } label: {
                        if !(vm.locationRegion?.center.equals(to: vm.getUsersLocation().center) ?? false) {
                            Image(systemName: "location")
                                //.padding(10)
                        } else {
                            Image(systemName: "location.fill")
                                //.padding(10)
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                Spacer()
                if !vm.isSharing {
                Button(action: {
                    vm.startLocationSharing()
                }, label: {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Helyzetmegosztás elindítása")
                    }
                })
                .buttonStyle(SimpleButtonStyle())
                .padding(.bottom, 20)
                } else {
                    Button(action: {
                        vm.stopLocationSharing()
                    }, label: {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Helyzetmegosztás leállítása")
                        }
                    })
                    .buttonStyle(SimpleButtonStyle())
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct NappaliPortyaView_Previews: PreviewProvider {
    static var previews: some View {
        NappaliPortyaView()
    }
}
