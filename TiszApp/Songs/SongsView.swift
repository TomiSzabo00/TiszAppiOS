//
//  SongsView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 12..
//

import SwiftUI

struct SongsView: View {
    
    @StateObject var vm = SongsViewModel()
    
    @State var predictableValues: Array<String> = []
    @State var predictedValue: Array<String> = []
    @State var prefix: String = "Keresés a számok között"
    
    @State var searchText: String = ""
    
    var body: some View {
        TabView {
            
                //first page
                VStack {
                    PredictingTextField(predictableValues: $vm.songTitles, predictedValues: self.$predictedValue, textFieldInput: $searchText, textFieldTitle: prefix)
                        .padding()
                    if self.predictedValue.count > 0 {
                        Text("Találat(ok) a keresésre:")
                            .padding()
                        List(self.predictedValue, id: \.self) {title in
                            NavigationLink(destination: SpecificSongView(title: vm.songs[vm.songTitles.firstIndex(of: title) ?? 0], lyrics: vm.songLyrics[vm.songTitles.firstIndex(of: title) ?? 0]), label: { Text(vm.songTitles[vm.songTitles.firstIndex(of: title) ?? 0]) })
                        }
                    } else {
                        Text("Tartalomjegyzék:")
                            .padding()
                        List(0...vm.songs.count-1, id: \.self) {i in
                            NavigationLink(destination: SpecificSongView(title: vm.songs[i], lyrics: vm.songLyrics[i]), label: { Text(vm.songTitles[i]) })
                        }
                    }
                } //end of first page
            
            //every other pge
            ForEach(1...(vm.songs.count), id: \.self) {i in
                SpecificSongView(title: vm.songs[i-1], lyrics: vm.songLyrics[i-1])
            }
        }
        .tabViewStyle(.page)
        
        .navigationTitle("Daloskönyv")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
    }
}
