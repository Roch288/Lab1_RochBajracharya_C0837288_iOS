//
//  ViewController.swift
//  Lab1_RochBajracharya_C0837288_iOS
//
//  Created by Roch on 17/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var crossScoreLabel: UILabel!
    @IBOutlet weak var noughtScoreLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    
    var turn = "X";
    var crossScore = 0
    var noughtScore = 0
    
    var noughtPosition = [Int]();
    var crossPosition = [Int]();
    
    var winningPositions = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]];
    
    var hasWinner = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        turnLabel.text = turn
        crossScoreLabel.text = String(crossScore)
        noughtScoreLabel.text = String(noughtScore)
    }
    
    @IBAction func tileClickHandler(_ sender: UIButton) {
        if sender.image(for: .normal) == nil && message.text == "" {
            // set image to cross or nought
            sender.setImage(UIImage(named: self.turn == "X" ? "cross" : "nought"), for: .normal);
            
            // For fade in Animation
            sender.imageView?.alpha = 0
            
            UIView.animate(withDuration: 1){
                sender.imageView?.alpha = 1
            }
            
            // store position of player
            turn == "X" ? crossPosition.append(sender.tag) : noughtPosition.append(sender.tag)
            
            // check wheather any player has won
            for positions in winningPositions {
                if turn == "X" {
                    let winningSet = Set(positions);
                    let crossSet = Set(crossPosition);
                    let isWinner = winningSet.isSubset(of: crossSet);
                    if isWinner {
                        message.text = "Congratulations! Cross is Winner"
                        hasWinner = true
                        crossScore += 1
                        crossScoreLabel.text = String(crossScore)
                    }
                } else {
                    let winningSet = Set(positions);
                    let noughtSet = Set(noughtPosition);
                    let isWinner = winningSet.isSubset(of: noughtSet);
                    if isWinner {
                        message.text = "Congratulations! Nought is Winner"
                        hasWinner = true
                        noughtScore += 1
                        noughtScoreLabel.text = String(noughtScore)
                    }
                }
                
                if !hasWinner && (crossPosition.count + noughtPosition.count) == 9 {
                    message.text = "It's a Draw"
                }
                
            }
            
            // toggle player turns
            turn = turn == "X" ? "O" : "X"
        }
    }
    
    
    
}

