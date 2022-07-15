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
            //Map(coordinateRegion: Binding($vm.locationRegion) ?? $vm.tiszapuspokiFaluCoords, interactionModes: MapInteractionModes.all, showsUserLocation: true, userTrackingMode: $vm.trackingMode)
            MapView(vm: vm)
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
                    Button {
                        vm.centerMap()
                    } label: {
                        Image(systemName: "location.fill")
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                    .opacity(0.8)

                    Spacer()
                }
                Spacer()

                if sessionService.userDetails?.admin ?? false {
                    HStack {
                        Button(action: { vm.down() }, label: {Image(systemName: "arrow.left").padding()})
                            .disabled(vm.currTeam == 0)
                        Text("\(vm.currTeam)")
                        Button(action: { vm.up() }, label: {Image(systemName: "arrow.right").padding()})
                            .disabled(vm.currTeam == sessionService.teamNum)
                    }
                    .padding()
                    //.opacity(1.0)
                } else {
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
}

struct NappaliPortyaView_Previews: PreviewProvider {
    static var previews: some View {
        NappaliPortyaView()
    }
}
