//
//  EjjeliPortyaView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 08..
//

import SwiftUI

struct EjjeliPortyaView: View {
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @StateObject var vm = EjjeliPortyaViewModel()
    
    var body: some View {
        VStack {
            Text("A helymeghatározás állapota: " + (vm.isSharing ? "Aktív" : "Szünetel"))
                .padding()

            Button(action: {
                vm.startLocationSharing()
            }, label: {
                Text("Helymeghatározás indítása")
            })
            .buttonStyle(SimpleButtonStyle())
            .padding()
            
            Button(action: {
                vm.stopLocationSharing()
            }, label: {
                Text("Helymeghatározás leállítása")
            })
            .buttonStyle(SimpleButtonStyle())
            .padding()
            
        }
        .frame(maxWidth: .infinity)
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
        .navigationTitle("Éjjeli Portya")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct EjjeliPortyaView_Previews: PreviewProvider {
    static var previews: some View {
        EjjeliPortyaView()
    }
}
