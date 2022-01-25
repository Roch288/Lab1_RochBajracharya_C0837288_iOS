//
//  Player.swift
//  Lab1_RochBajracharya_C0837288_iOS
//
//  Created by Roch on 18/01/2022.
//

import Foundation
import UIKit

var winningPositions = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]];
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

extension Player {
    
    // Win - 1, Loose - 0, Draw - -1
    func checkWin() -> Int {
        // check if player's positions are the winning positions
        for wp in winningPositions {
            let winningSet = Set(wp)
            let playerSet = Set(positons ?? [])
            let isWinner = winningSet.isSubset(of: playerSet)
            if isWinner {
                return 1
            }
        }
        
        // check if player has already occupied more than 4 positions without winning and if yes, it's a draw
        if self.positons?.count ?? 0 > 4 {
            return -1
        }
        
        // player's hasn't won
        return 0
    }
    
    // function to record move made by player
    func makeMove(position:Int){
        if positons == nil {
            positons = [position]
        } else {
            positons?.append(position)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving player position \(error.localizedDescription)")
        }
    }
    
    // function to undo last move made by player
    func undoMove(){
        positons?.removeLast()
        do {
            try context.save()
        } catch {
            print("Error saving player position \(error.localizedDescription)")
        }
    }
    
    // return win Messsage
    func winMessage() -> String {
        return "Congratulations! " + (value == "Cross" ? "Cross" : "Nought") + " is Winner";
    }
    
    // reset Player
    func resetPlayer(newGame:Bool){
        positons?.removeAll()
        if newGame {
            score = 0
        }
        do {
            try context.save()
        } catch {
            print("Error saving player position \(error.localizedDescription)")
        }
    }
    
}
