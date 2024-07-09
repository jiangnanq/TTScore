//
//  ContentView.swift
//  TTScore
//
//  Created by Joshua Jiang on 3/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            matchView()
                .tabItem {
                    Image(systemName:"1.circle")
                    Text("Match")
                }
            playerView()
                .tabItem {
                    Image(systemName:"2.circle")
                    Text("Player")
                }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    ContentView()
}
