//
//  EjjeliPortyaAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 08..
//

import SwiftUI
import MapKit

struct EjjeliPortyaAdminView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject private var vm: EjjeliPortyaViewModel = EjjeliPortyaViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.tiszapuspoki_coords, showsUserLocation: false, annotationItems: vm.markers){ marker in
                MapMarker(coordinate: marker.coordinate, tint: marker.tint)
            }
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
                Spacer()
                Button(action: {
                    vm.uploadLocationOnce()
                }, label: {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Helyzet frissítése")
                    }
                    //.frame(width: 130, height: 15)
                })
                .buttonStyle(SimpleButtonStyle())
                .padding(.bottom, 20)
            }
        }
        .toolbar(content: {
            Button(action: {
                vm.uploadColorsToDB()
            }, label: {
                Image(systemName: "paintpalette")
            })
        })
    }
}

struct EjjeliPortyaAdminView_Previews: PreviewProvider {
    static var previews: some View {
        EjjeliPortyaAdminView().environmentObject(SessionServiceImpl())
    }
}
