//
//  MainView.swift
//  TTScore
//
//  Created by Joshua Jiang on 3/5/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Match", systemImage: "list.dash")
                }
        }
    }
}

}
