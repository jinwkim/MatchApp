//
//  CardModel.swift
//  MatchApp
//
//  Created by Jin Kim on 6/15/20.
//  Copyright © 2020 Jin Kim. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        // Declare an empty array to store all cards
        var generatedCards = [Card]()
        
        // Extra array to check if random number has been used or not
        var used = [Int]()
        
        // Randomly generate 8 pairs of cards
        for _ in 1...8 {
            // Generate a random number
            var randomNumber = Int.random(in: 1...13)
            
            while used.contains(randomNumber) {
                randomNumber = Int.random(in: 1...13)
            }
            
            // Add new unique randomNumber to "used" array
            used.append(randomNumber)
            
            // Create two new card objects
            let card1 = Card()
            let card2 = Card()
            
            // Set their image names
            card1.imageName = "card\(randomNumber)"
            card2.imageName = "card\(randomNumber)"
            
            // Add to array
            generatedCards.append(card1)
            generatedCards.append(card2)
            
            print(randomNumber)
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle() // use Array class API "shuffle"
        
        // Return the array
        return generatedCards
    }
}
