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
    @State var prefix: String = "Cím vagy dalszöveg alapján"
    
    @State var searchText: String = ""
    
    var body: some View {
        TabView {
            
                //first page
                VStack {
                    HStack {
                        Text("Keresés a dalok között:")
                            .padding(.leading)
                        Spacer()
                    }
                    
                    FilterSongsTextField(titles: $vm.songTitles, lyrics: $vm.songLyrics, predictedValues: self.$predictedValue, textFieldInput: $searchText, textFieldTitle: prefix)
                        .padding([.leading, .trailing, .bottom])
                    
                    HStack {
                        Text("Dalok:")
                            .padding()
                        Spacer()
                    }
                    if self.predictedValue.count > 0 {
                        List(self.predictedValue, id: \.self) {title in
                            NavigationLink(destination: SpecificSongView(title: vm.songs[vm.songTitles.firstIndex(of: title) ?? 0], lyrics: vm.songLyrics[vm.songTitles.firstIndex(of: title) ?? 0]), label: { Text(vm.songTitles[vm.songTitles.firstIndex(of: title) ?? 0]) })
                        }
                    } else {
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
