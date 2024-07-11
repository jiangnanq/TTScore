//
//  matchView.swift
//  TTScore
//
//  Created by Joshua Jiang on 4/5/24.
//

import SwiftUI

struct matchView: View {
    @StateObject private var dm = DataManager.shared
    @State private var showDetailView: Bool = false
    @State private var showAlert = false
    @State private var scoreAlert = false
    @State private var selectMatchIndex = 0
    @State private var score1 = ""
    @State private var score2 = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<dm.matches.count, id:\.self) { index in
                    let onematch  = dm.matches[index]
                    Text(onematch.displayText())
                        .onTapGesture {
                            scoreAlert = true
                            selectMatchIndex = index
                        }
                }
            }
            .alert("Test", isPresented: $scoreAlert) {
                let oneMatch = dm.matches[selectMatchIndex]
                TextField("\(oneMatch.player1)", text: $score1)
                    .keyboardType(.numberPad)
                    .padding()
                TextField("\(oneMatch.player2 )", text: $score2)
                    .keyboardType(.numberPad)
                    .padding()
                HStack{
                    Button(action: {
                        let oneMatch = dm.matches[selectMatchIndex]
                        dm.updateMatchScore(matchid: oneMatch.id, score1: Int(score1)!, score2: Int(score2)!)
                        score1 = ""
                        score2 = ""
                    }){ Text("ok")}
                        .padding()
                    Spacer()
                    Button("Cancel", role: .cancel) {}
                        .padding()
                }
            }
            .navigationBarItems(trailing: Button(action: {self.showAlert = true}) {
                Image(systemName: "arrow.counterclockwise")
            }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Reset match"), primaryButton: .destructive(Text("Yes")){
                    print("reset match")
                    dm.resetMatch()
                }, secondaryButton: .cancel())
            }
            .navigationTitle("Match")
        }
    }
}

//#Preview {
//    matchView()
//}
