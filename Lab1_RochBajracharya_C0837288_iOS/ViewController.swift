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
    @IBOutlet weak var swipeMessage: UILabel!
    
    // Initializing players
    var crossPlayer = Player(value: .Cross, inidicator: "X", positions: [], score: 0, image: "cross")
    var noughtPlayer = Player(value: .Nought, inidicator: "O", positions: [], score: 0, image: "nought")
    
    var turn:Player? = nil;
    
    // record player moves to make it easier to reset game
    var clickedButtons = [UIButton]()
    // To inidicate if game is over
    var gameComplete = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        turn = crossPlayer
        turnLabel.text = turn!.inidicator
        crossScoreLabel.text = String(turn!.score)
        noughtScoreLabel.text = String(turn!.score)
        swipeMessage.isHidden = true
    }
    
    @IBAction func tileClickHandler(_ sender: UIButton) {
           
            // reset board if game is complete
            if gameComplete {
                resetGame(isNewGame: false)
            }
        
            // check if box is empty
            if sender.image(for: .normal) == nil && message.text == "" {
               
                // set image to cross or nought
                sender.setImage(UIImage(named: turn!.image), for: .normal);
                clickedButtons.append(sender) // store button to clear image when played again
                
                // For fade in Animation
                sender.imageView?.alpha = 0
                UIView.animate(withDuration: 1){
                    sender.imageView?.alpha = 1
                }
                
                // store position of player
                turn!.makeMove(position: sender.tag)
                
                // check wheather any player has won
                let playerWon = turn!.checkWin();
                if playerWon == 1 {
                    message.text = turn!.winMessage()
                    swipeMessage.isHidden = false
                    gameComplete = true
                    turn!.score += 1
                    if turn!.value == Type.Cross {
                        crossScoreLabel.text = String(crossPlayer.score)
                    } else {
                        noughtScoreLabel.text = String(noughtPlayer.score)
                    }
                } else if playerWon == -1 {
                    message.text = "It's a Draw"
                    swipeMessage.isHidden = false
                    gameComplete = true;
                }
                
                // toggle player turns
                turn = turn!.value == Type.Cross ? noughtPlayer : crossPlayer
                turnLabel.text = turn!.inidicator
            }
        
    }
    
    // Action for Right Swipe Gesture
    @IBAction func newGame(_ sender: UISwipeGestureRecognizer) {
        // let user start new game only one or more game has been played
        if sender.direction == .right && (crossPlayer.score > 0 || noughtPlayer.score > 0) {
            // To show alert box and ask if user wants to start new game
            // Prevent accidental swipe game reset
            let message = "Are you sure you want to reset this game?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (_) in
                self.resetGame(isNewGame: true)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(ac, animated: true)
        }
    }
    
    // To reset all attributes for a new game
    func resetGame(isNewGame: Bool){
        for button in clickedButtons {
            button.setImage(nil, for: .normal)
        }
        
        message.text = ""
        crossPlayer.resetPlayer(newGame: isNewGame)
        noughtPlayer.resetPlayer(newGame: isNewGame)
        swipeMessage.isHidden = true;
        gameComplete = false
        
        if isNewGame {
            crossScoreLabel.text = "0"
            noughtScoreLabel.text = "0"
        }
    }
    
}

