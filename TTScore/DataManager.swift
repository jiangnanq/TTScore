//
//  DataManager.swift
//  TTScore
//
//  Created by Joshua Jiang on 4/5/24.
//

import Foundation

class Match: Equatable, Identifiable, Comparable{
    var id: UUID
    var player1: String
    var player2: String
    var score1: Int
    var score2: Int
    var winner: String {
        get {
            guard score1 != score2 else {
                return ""
            }
            return score1 > score2 ? player1 : player2
        }
    }
    
    init(onerow:[String]){
        self.id = UUID(uuidString: onerow[0])!
        self.player1 = onerow[1]
        self.player2 = onerow[2]
        self.score1 = Int(onerow[3])!
        self.score2 = Int(onerow[4])!
    }
    
    init(player1: String, player2: String) {
        self.id = UUID()
        self.player1 = player1
        self.player2 = player2
        self.score1 = 0
        self.score2 = 0
    }
    
    static func == (match1: Match, match2: Match) -> Bool {
        return (match1.player1 == match2.player1 && match1.player2 == match2.player2) || (match1.player1 == match2.player2 && match1.player2 == match2.player1)
    }
    
    func displayText() -> String {
        return "\(self.player1) \(self.score1) : \(self.score2) \(self.player2)"
    }
    
    func toRow() -> [String] {
        return [id.uuidString, player1, player2, String(score1), String(score2)]
    }
    
    func containPlayer(playername: String) -> Bool {
        return playername == player1 || playername == player2
    }
    
    static func < (lhs: Match, rhs: Match) -> Bool {
        lhs.player1 < rhs.player1
    }
    
    func resetScore() {
        score1 = 0
        score2 = 0
    }
}

class Player: Comparable, Equatable {
    var playerName: String
    var win: Int
    var lose: Int
    var winSub: Int
    var loseSub: Int
    var description: String {
        get {
            if winSub == 0 && loseSub == 0 {return ""}
            return "Win: \(win) Lose: \(lose) (\(winSub) \(loseSub))"
        }
    }
    
    var winPoints: Int {
        winSub - loseSub
    }
    init(playerName: String) {
        self.playerName = playerName
        win=0; lose=0; winSub=0; loseSub=0
    }
    
    func updateScore(match: Match) {
        guard !match.winner.isEmpty && (match.player1 == playerName || match.player2 == playerName)  else {
           return
        }
        if match.winner == playerName {win += 1} else { lose += 1}
        if match.player1 == playerName {
            winSub += match.score1
            loseSub += match.score2
        } else {
            winSub += match.score2
            loseSub += match.score1
        }
    }
    
    static func == (lhs: Player, rhs:Player) -> Bool {
        lhs.win == rhs.win && lhs.lose == rhs.lose && lhs.winSub == rhs.winSub && lhs.loseSub == rhs.loseSub
    }
    
    static func < (lhs: Player, rhs:Player) -> Bool {
        if lhs.win != rhs.win {return lhs.win < rhs.win}
        if lhs.winPoints != rhs.winPoints { return (lhs.winPoints < rhs.winPoints)}
        return lhs.playerName < rhs.playerName
    }
    
    func resetScore() {
        win = 0
        lose = 0
        winSub = 0
        loseSub = 0
    }
}

class DataManager: ObservableObject{
    static let shared = DataManager()
    @Published var players:[Player] = [] {
        didSet {
            UserDefaults.standard.setValue(players.map{$0.playerName}, forKey: "players")
        }
    }
    @Published var matches: [Match] = [] {
        didSet {
            UserDefaults.standard.setValue(self.matches.map{$0.toRow()}, forKey: "matches")
        }
    }
    
    private init() {
        var playersName = UserDefaults.standard.array(forKey: "players") as! [String]
        playersName.removeAll(where: {$0 == "player1"})
        players = playersName.map{Player(playerName: $0)}
        let m = UserDefaults.standard.array(forKey: "matches") as! [[String]]
        self.matches = m.map{Match(onerow: $0)}
        self.matches.removeAll(where: { $0.player1 == "player1" && $0.player2 == "player2"})
        reloadScore()
    }
    
    func reloadScore() {
         for onematch in matches {
            for oneplayer in players {
                oneplayer.updateScore(match: onematch)
            }
        }
    }
    
    func addPlayer(playername: String) {
        if !self.players.map{$0.playerName}.contains(playername) && !playername.isEmpty{
            // Add player's match
            for oneplayer in players.map{$0.playerName} {
                matches.append(Match(player1: playername, player2: oneplayer))
            }
            players.append(Player(playerName: playername))
        }
    }
    
    func deletePlayer(index: Int) {
        matches = matches.filter{!$0.containPlayer(playername: players.map{$0.playerName}[index])}
        players.remove(at: index)
    }
    
    func updateMatchScore(matchid: UUID, score1: Int, score2: Int) {
        var onematch = matches.filter{$0.id == matchid}.first!
        onematch.score1 = score1
        onematch.score2 = score2
        for oneplayer in players {
            oneplayer.updateScore(match: onematch)
        }
        players = players.sorted().reversed()
        UserDefaults.standard.setValue(self.matches.map{$0.toRow()}, forKey: "matches")
    }
    
    func resetMatch() {
        self.matches = matches.map{Match(player1: $0.player1, player2: $0.player2)}
        self.players = players.map{Player(playerName: $0.playerName)}
        UserDefaults.standard.setValue(self.matches.map{$0.toRow()}, forKey: "matches")
    }
}
