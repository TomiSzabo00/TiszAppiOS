//
//  TreasureHuntAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 26..
//

import SwiftUI

struct TreasureHuntAdminView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject var vm = TreasureHuntViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Mely csapatok láthatják a Wordle nyomot a kincskeresésben?")
                Spacer()
            }
            .padding()
            
            VStack {
                ForEach($vm.toggles, id: \.id) { $toggle in
                    Toggle("\((vm.toggles.firstIndex(of: toggle) ?? -1)+1). csapat", isOn: $toggle.state)
                        .onChange(of: toggle.state) { value in
                            vm.refreshStates()
                        }
                }
            }
            .padding()
        }
        .onAppear {
            self.vm.sessionService = self.sessionService
            self.vm.initToggles()
        }
    }
}

struct TreasureHuntAdminView_Previews: PreviewProvider {
    static var previews: some View {
        TreasureHuntAdminView()
    }
}
