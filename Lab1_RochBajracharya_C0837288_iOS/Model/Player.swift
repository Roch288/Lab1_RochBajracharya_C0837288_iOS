//
//  Player.swift
//  Lab1_RochBajracharya_C0837288_iOS
//
//  Created by Roch on 18/01/2022.
//

import Foundation

enum Type {
case Cross
case Nought
}

var winningPositions = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]];

class Player {
    var value: Type
    var inidicator: String
    var positons: [Int]
    var score: Int
    var image: String
    
    init(value:Type, inidicator:String, positions:[Int], score:Int,image: String){
        self.value = value
        self.inidicator = inidicator
        self.positons = positions
        self.score = score
        self.image = image
    }
    
    // Win - 1, Loose - 0, Draw - -1
    func checkWin() -> Int {
        // check if player's positions are the winning positions
        for wp in winningPositions {
            let winningSet = Set(wp)
            let playerSet = Set(self.positons)
            let isWinner = winningSet.isSubset(of: playerSet)
            if isWinner {
                return 1
            }
        }
        
        // check if player has already occupied more than 4 positions without winning and if yes, it's a draw
        if self.positons.count > 4 {
            return -1
        }
        
        // player's hasn't won
        return 0
    }
    
    // function to record move made by player
    func makeMove(position:Int){
        self.positons.append(position)
    }
    
    // return win Messsage
    func winMessage() -> String {
        return "Congratulations! " + (self.value == Type.Cross ? "Cross" : "Nought") + " is Winner";
    }
    
    // reset Player
    func resetPlayer(newGame:Bool){
        self.positons.removeAll()
    }
    
}
