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
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 20*1000 // 20 seconds
    
    var firstFlippedCardIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Generate cards to be used in the game
        cardsArray = model.getCards()
        
        // Set the view controller as datasource and delegate of collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common) // to prevent stopping timer when touching screen
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the time counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the cards
            checkForGameEnd()
        }
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
            
            // Was that the last pair?
            checkForGameEnd()
        } else {
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Not a match, flip the cards back down
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        // Check if there's any card that is unmatched
        // Assume the user has won, loop through all cards to see if all are matched
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                
                // Found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            
            // user has won -- show dialogue
            showAlert(title: "Congratulations!", message: "You won the game!")
            
        } else {
            
            // user hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Time is up!", message: "Better luck next time.")
            }
            
        }
        
    }
    
    func showAlert(title:String, message:String){
        
        // Add alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add button for user to dismiss alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

