//
//  ViewController.swift
//  Concentration
//
//  Created by Adolphe M. on 04/10/2018.
//  Copyright © 2018 Adolphe M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        for i in cardButtons.indices {
            cardButtons[i].layer.cornerRadius = 15
            cardButtons[i].animation = "squeezeDown"
            cardButtons[i].delay = CGFloat(i) * 0.01
            cardButtons[i].duration = CGFloat(1)
            cardButtons[i].animate()
        }
        
        newGameButton.layer.cornerRadius = 15       
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }
    
    private func updateFlipCountLabel(){
        flipCountLabel.text = "Flips \(game.flipCount)"
    }
    
    private func updateScoreCountLabel(){
        scoreCountLabel.text = "Score: \(game.score)"
    }
    @IBOutlet var newGameButton: SpringButton!
    @IBAction private func newGameButtonPress() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        newGameButton.animation = "swing"
        newGameButton.duration = CGFloat(0.2)
        newGameButton.animate()
        updateViewFromModel()
        
        for i in cardButtons.indices {
            cardButtons[i].animation = "squeezeRight"
            cardButtons[i].delay = CGFloat(i) * 0.01
            cardButtons[i].duration = CGFloat(1)
            cardButtons[i].animateNext {
                //cardButtons[i].x = CGFloat(-20)
            }
        }
        
    }
    @IBOutlet weak var scoreCountLabel: SpringLabel! {
        didSet{
            updateScoreCountLabel()
        }
    }
    @IBOutlet private weak var flipCountLabel: SpringLabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [SpringButton]!
    @IBAction private func touchCard(_ sender: SpringButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            cardButtons[cardNumber].animation = "flipX"
            cardButtons[cardNumber].duration = CGFloat(0.2)
            cardButtons[cardNumber].animateToNext(completion: updateViewFromModel)
        } else {
            print("Chosen card not found in cardButtons")
        }
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 0.5073309075): #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreCountLabel()
    }
    private var emoji = [Card:String]()
    private func emoji(for card: Card) -> String
    {
        if emoji[card] == nil, game.emojiTheme.count > 0
        {
            let randomStringIndex = game.emojiTheme.index(game.emojiTheme.startIndex, offsetBy: game.emojiTheme.count.arc4random)
            emoji[card] = String(game.emojiTheme.remove(at: randomStringIndex))
        }
      return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if(self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        } else if self  < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }
        return 0
    }
}
