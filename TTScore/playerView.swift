//
//  playerView.swift
//  TTScore
//
//  Created by Joshua Jiang on 3/5/24.
//

import SwiftUI

struct playerView: View {
    @StateObject private var dm = DataManager.shared
    @State private var showAlert = false
    @State private var playername = ""
    var body: some View {
        NavigationStack{
            List {
                ForEach(0..<dm.players.count, id:\.self) { index in
                    let oneplayer = dm.players.sorted().reversed()[index]
                    Text("\(index + 1)  \(oneplayer.playerName) \n \(oneplayer.description)")
                }
                .onDelete(perform: { indexSet in
                    dm.deletePlayer(index: indexSet.first!)
                })
            }
            .toolbar {
                Button("Create") {
                    showAlert.toggle()
                }.alert("Add player", isPresented: $showAlert) {
                    TextField("Enter player name", text: $playername)
                        .disableAutocorrection(true)
                    Button("OK", action: submit)
                    Button("Cancel", role:.cancel) {}
                }
            }
            .navigationTitle("Players")
        }
    }
    func submit() {
        dm.addPlayer(playername: playername)
        playername = ""
    }
}

#Preview {
    playerView()
}
