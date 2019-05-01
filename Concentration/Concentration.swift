//
//  Concentration.swift
//  Concentration
//
//  Created by Adolphe M. on 05/10/2018.
//  Copyright © 2018 Adolphe M. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    private(set) var score: Int
    private(set) var flipCount: Int
    internal var emojiTheme: String
    private var previouslyFlippedCards = [Card]()
    private var indexOfSingleFaceUpCard: Int?{
        get {
            return cards.indices.filter { cards[$0].isFaceUp && !cards[$0].isMatched }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = cards[index].isMatched ? true : (index == newValue)
            }
        }
    }
    
    private func checkForPenalty(forCardAt index: Int){
        if previouslyFlippedCards.contains(cards[index]){
            score += score >= 1 ? -1: 0
        }
    }
    
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards.")
        previouslyFlippedCards.append(cards[index])
        previouslyFlippedCards.forEach({ print($0) })
        // Only does something if card hasn't been matched yet
        if !cards[index].isMatched{
            // if there is max 1 other card facing up
            if let matchIndex = indexOfSingleFaceUpCard, matchIndex != index {
                // is it a match?
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 3
                } else {
                    if previouslyFlippedCards.contains(cards[index]) || previouslyFlippedCards.contains(cards[matchIndex]) {
                        score += score >= 1 ? -1: 0
                    }
                }
            } else { // otherwise simply flip this card face up
               indexOfSingleFaceUpCard = index
            }
        }
        cards[index].isFaceUp = true
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int){
        score = 0
        flipCount = 0
        
        // Enter new string to array to add new theme
        let themeOptions = [
            "💃🏽⚙️🕺🏽👑💍🙈🦋🔥⭐️🥃🔑🎁📚♥️💠🎵♠️♞♝♟♜♛♚♔♕♖♘♙♗🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🍍🥭🥥🥝🍅🥓🥩🍗🍖🌭🍔🍟🍕🥪🥙🌮🌯🥗🥘🥫🍝🍜🍲⚽️🏀🏈⚾️🥎🏐🏉🎾🎱🏓🗾🎑🏞🌅🌄🌠🎇🎆🌇🌆🏙🌃🌌🌉🌁"
        ]
        // determine random emoji theme
        emojiTheme = themeOptions[themeOptions.count.arc4random]
        for _ in  0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
