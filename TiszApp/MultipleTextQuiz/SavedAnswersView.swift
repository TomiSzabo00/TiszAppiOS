//
//  SavedAnswersView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 26..
//

import SwiftUI
import FirebaseDatabase

struct SavedAnswersView: View {
    @StateObject var vm: MultipleTextQuizViewModel

    @State var snapshot: DataSnapshot

    var body: some View {
        HStack {
            Text("Mentett válaszok listája:")
            Spacer()
        }
        .padding(.leading)
        .onAppear {
            vm.getSavedAnswers(from: snapshot)
            vm.resetItemColor()
        }

        List(vm.allAnswers, id: \.self) { group in
            if !group.isEmpty {
                NavigationLink("\(((vm.allAnswers.firstIndex(of: group)) ?? 0)+1). csapat válasza(i)", destination: MultipleTextQuizAnswersView(vm: vm, answers: group, currTeam: (vm.allAnswers.firstIndex(of: group) ?? 0)+1))
            }
        }
        .padding([.leading, .trailing])
    }
}

