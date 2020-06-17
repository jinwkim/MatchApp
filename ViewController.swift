//
//  ViewController.swift
//  MatchApp
//
//  Created by Jin Kim on 6/15/20.
//  Copyright © 2020 Jin Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Generate cards to be used in the game
        cardsArray = model.getCards()
        
        // Set the view controller as datasource and delegate of collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // Collection View Delegate Methods
    
    // Required of UICollectionViewDataSource
    // Number of items per section == 16 cards (8 pairs of cards)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }

    // Required of UICollectionViewDataSource
    // Return whole UIColletionViewCell object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell -- deque, if not create a new cell
        // Creating a new cell object each time takes up too much memory
        // Cast cell (default UICollectionViewCell) to CardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell

//        // Get the card from card array
//        let card = cardsArray[indexPath.row]
//
//        // Configure the cell
//        cell.configureCell(card: card)

        // Return the cell
        return cell
    }
    
    // collectionView notifying the delegate ahead of time for display
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        
        // Cast cell to CardCollectionViewCell
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from card array
        let card = cardsArray[indexPath.row]

        // Configure the cell
        cardCell?.configureCell(card: card)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell

        // Use optional in case cell is nil

        // Check the status of card to determine how to flip
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp(speed: 0.3)
            
            // Check if this is the first flipped card or second flipped card
            if firstFlippedCardIndex == nil {
                
                // This is the first card flipped over
                firstFlippedCardIndex = indexPath
            } else {
                
                // This is the second card flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }

    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two IndexPaths, see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the 2 collection view cells representing cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards via imageName "card1","card2",...
        if cardOne.imageName == cardTwo.imageName  {
            
            // Match found -- set status and remove cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            
            // Not a match, flip the cards back down
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
}

