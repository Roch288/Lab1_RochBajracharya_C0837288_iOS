//
//  ViewController.swift
//  Lab1_RochBajracharya_C0837288_iOS
//
//  Created by Roch on 17/01/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var crossScoreLabel: UILabel!
    @IBOutlet weak var noughtScoreLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var swipeMessage: UILabel!
    @IBOutlet weak var boardStack: UIStackView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Initializing players
    var crossPlayer: Player!
    var noughtPlayer: Player!
    
    var turn:Player? = nil;
    
    // record player moves to make it easier to reset game
    var clickedButtons = [UIButton]()
    // To inidicate if game is over
    var gameComplete = false
    
    var undoCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeMessage.isHidden = true
        loadPlayer()
        
        // Get all buttons from stack view
        for case let horizontalStackView as UIStackView in boardStack.arrangedSubviews {
                    for case let button as UIButton in horizontalStackView.arrangedSubviews {
                        // check if the position is filled by cross or nought
                        let hasCross = crossPlayer.positons?.first(where: {$0 == button.tag}) != nil
                        let hasNought = noughtPlayer.positons?.first(where: {$0 == button.tag}) != nil
                        if hasCross || hasNought {
                            clickedButtons.append(button)
                            button.setImage(UIImage(named: (hasCross ? crossPlayer.image : noughtPlayer.image)!), for: .normal)
                        }
                    }
                }
        
    }
    
    
    // MARK: Core Data Methods
    func initPlayer() {
        crossPlayer = Player(context: context)
        crossPlayer.value = "Cross"
        crossPlayer.inidicator = "X"
        crossPlayer.image = "cross"
        
        noughtPlayer = Player(context: context)
        noughtPlayer.value = "Nought"
        noughtPlayer.inidicator = "O"
        noughtPlayer.image = "nought"
        
        do {
            try context.save()
        } catch {
            print("Error saving player \(error.localizedDescription)")
        }
        
    }
    
    func loadPlayer() {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        
        do {
            let players = try context.fetch(request)
            if players.count == 0 {
                initPlayer()
            } else {
                crossPlayer = players.first(where: {$0.value == "Cross"})
                noughtPlayer = players.first(where: {$0.value == "Nought"})
                
            }
            turn = crossPlayer
            turnLabel.text = turn!.inidicator
            crossScoreLabel.text = String(crossPlayer!.score)
            noughtScoreLabel.text = String(noughtPlayer!.score)
            checkHasWin()
        } catch {
            print("Error loading players \(error.localizedDescription)")
        }
    }
    
    // MARK: LAB TEST 2: Shake motion
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && clickedButtons.count > 0 && !gameComplete && undoCount == 0  {
            undoCount += 1
            // change turn back to previous player
            turn = turn!.value == "Cross" ? noughtPlayer : crossPlayer
            turn?.undoMove()
            
            // remove image from last tapped button
            clickedButtons.last?.setImage(nil, for: .normal)
            clickedButtons.removeLast()
            
            // change turn label
            turnLabel.text = turn!.inidicator
        }
    }
    
    @IBAction func tileClickHandler(_ sender: UIButton) {
        
        // reset board if game is complete
        if gameComplete {
            resetGame(isNewGame: false)
        }
        
        // check if box is empty
        if sender.image(for: .normal) == nil && message.text == "" {
            undoCount = 0
            
            // set image to cross or nought
            sender.setImage(UIImage(named: turn!.image!), for: .normal);
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
                do {
                    try context.save()
                } catch {
                    print("Error saving player position \(error.localizedDescription)")
                }
                if turn!.value == "Cross" {
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
            turn = turn!.value == "Cross" ? noughtPlayer : crossPlayer
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
    
    // check win when first data loaded
    func checkHasWin(){
        let crossWon = crossPlayer!.checkWin();
        let noughtWon = noughtPlayer!.checkWin();
        if crossWon == 1 || noughtWon == 1 {
            message.text = crossWon == 1 ? crossPlayer!.winMessage() : noughtPlayer.winMessage()
            swipeMessage.isHidden = false
            gameComplete = true
        } else if crossWon == -1 || noughtWon == -1 {
            message.text = "It's a Draw"
            swipeMessage.isHidden = false
            gameComplete = true;
        }
    }
    
}

