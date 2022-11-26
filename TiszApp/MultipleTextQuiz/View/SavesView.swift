//
//  SavesView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 27..
//

import SwiftUI

struct SavesView: View {
    @StateObject var vm: MultipleTextQuizViewModel

    var body: some View {
        HStack {
            Text("Mentett válaszok listája:")
            Spacer()
        }
        .padding(.leading)

        List(vm.saves, id: \.self) { date in
            NavigationLink(date, destination: SavedAnswersView(vm: vm, snapshot: vm.savedSnapshots[vm.saves.firstIndex(of: date) ?? 0]))
        }
        .padding([.leading, .trailing])

        Spacer()

        Button("Mentett válaszok törlése") {

        }
        .padding()
    }
}

struct SavesView_Previews: PreviewProvider {
    static var previews: some View {
        SavesView(vm: MultipleTextQuizViewModel())
    }
}
