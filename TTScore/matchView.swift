//
//  matchView.swift
//  TTScore
//
//  Created by Joshua Jiang on 4/5/24.
//

import SwiftUI

struct matchDetailView: View {
    @StateObject private var dm = DataManager.shared
    @State var index: Int
    @State private var typeScore =  false
    @State private var score1 = ""
    @State private var score2 = ""
    
    var body: some View {
        let oneMatch = dm.matches[index]
        HStack {
            Text("\(index + 1)  \(oneMatch.player1)")
            Button("\(oneMatch.score1) : \(oneMatch.score2)") {
                typeScore = true
            }
            //            .alert("type score", isPresented: $typeScore) {
            //                TextField("\(oneMatch.player1)", text: $score1)
            //                    .keyboardType(.numberPad)
            //                    .padding()
            //                TextField("\(oneMatch.player2 )", text: $score2)
            //                    .keyboardType(.numberPad)
            //                    .padding()
            //                Button("Ok", action: updateScore)
            //                Button("Cancel", role:.cancel) {}
            //            }
            Text("\(oneMatch.player2)")
        }
        //        if showAlert {
        //            scoreForm(isPresented: $showAlert)
        //        }
    }
    
    func updateScore() {
        let oneMatch = dm.matches[index]
        dm.updateMatchScore(matchid: oneMatch.id, score1: Int(score1)!, score2: Int(score2)!)
    }
}

struct matchView: View {
    @StateObject private var dm = DataManager.shared
    @State private var showDetailView: Bool = false
    @State private var showAlert = false
    @State private var scoreAlert = false
    @State private var selectMatchIndex = 0
    @State private var score1 = "0"
    @State private var score2 = "0"
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<dm.matches.count, id:\.self) { index in
                    let onematch  = dm.matches[index]
                    let title = "\(index+1) \(onematch.player1) \(onematch.score1) : \(onematch.score2) \(onematch.player2)"
                    Text(title)
                        .onTapGesture {
                            scoreAlert = true
                            selectMatchIndex = index
                            score1 = String(dm.matches[selectMatchIndex].score1)
                            score2 = String(dm.matches[selectMatchIndex].score2)
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
                Button("ok", role: .cancel) {}
                Button("Cancel", role: .cancel) {}
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
