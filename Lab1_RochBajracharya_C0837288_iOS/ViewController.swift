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
    
    var turn = "X";
    var crossScore = 0
    var noughtScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        turnLabel.text = turn
        crossScoreLabel.text = String(crossScore)
        noughtScoreLabel.text = String(noughtScore)
    }
    
    @IBAction func tileClickHandler(_ sender: UIButton) {
        // set image to cross or nought
        sender.setImage(UIImage(named: self.turn == "X" ? "cross" : "nought"), for: .normal);
        
        // For fade in Animation
        sender.imageView?.alpha = 0
        
        UIView.animate(withDuration: 1){
            sender.imageView?.alpha = 1
        }
        
        // toggle player turns
        turn = turn == "X" ? "O" : "X"
    }
    
    
    
}

