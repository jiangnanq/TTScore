//
//  TTScoreApp.swift
//  TTScore
//
//  Created by Joshua Jiang on 3/5/24.
//

import SwiftUI

@main
struct TTScoreApp: App {
    init() {
        let m = Match(player1: "player1", player2: "player2")
        UserDefaults.standard.register(defaults: [
            "players": ["player1"],
            "matches":[m.toRow()]
        ])
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
