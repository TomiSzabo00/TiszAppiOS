//
//  WorldeHowTo.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 13..
//

import SwiftUI

struct WordleHowTo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Minden nap van egy 5 betűs szó, amit ki kell találnod. Hogyan?")
            Text("7 lehetőséged van tippelni, minden tipp egy értelmes, 5 betűből álló magyar szó kell legyen. A dupla betűk kettőnek számítanak.")
            Text("Ha beírtál egy szót, a \"Beküldés\" gombra nyomva ellenőrizheted a betűk helyességét. 3 féle eredményt láthatsz:")
            HStack(alignment: .center, spacing: 10) {
                LetterView(l: Letter("T"), bg: .gray, degrees: 0.0)
                Text("A szürke háttér azt jeleni, hogy ez a betű nincs benne a megfejtésben.")
            }
            HStack(alignment: .center, spacing: 10) {
                LetterView(l: Letter("P"), bg: .yellow, degrees: 0.0)
                Text("A sárga háttér azt jelenti, hogy ez a betű benne van a megfejtésben, csak nem az adott helyen.")
            }
            HStack(alignment: .center, spacing: 10) {
                LetterView(l: Letter("É"), bg: .green, degrees: 0.0)
                Text("A  zöld háttér azt jelenti, hogy ez a betű benne van a megfejtésben, pont az adott helyen.")
            }
            Text("Fontos, hogy egy betű szerepelhet többször is egy szóban.")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()

        .navigationTitle("Játékszabály")
    }
}

struct WordleHowTo_Previews: PreviewProvider {
    static var previews: some View {
        WordleHowTo()
    }
}
