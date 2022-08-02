//
//  NappaliPortyaView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 25..
//

import SwiftUI
import FirebaseDatabase

struct NappaliPortyaView: View {
    @Environment(\.openURL) var openURL

    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var ID: Int?

    @State private var links = [URL]()
    @State private var isLoading = true

    @StateObject var vm = NappaliPortyaViewModel()

    var body: some View {
        ZStack {
            Image("bg2_day")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            HStack {
                Spacer()

                IconButton(text: "Tértkép", icon: "map", action: {
                    ID = 1
                })

                Spacer()

                IconButton(text: "Képek, videók", icon: "icloud.and.arrow.up.fill", action: {
                    openURL(vm.links[sessionService.userDetails?.groupNumber ?? 0])
                })

                Spacer()
            }
            .padding()

        }

        NavigationLink(destination: WorkoutView().environmentObject(sessionService), tag: 1, selection: $ID) { EmptyView() }
    }
}

struct NappaliPortyaView_Previews: PreviewProvider {
    static var previews: some View {
        NappaliPortyaView()
    }
}
