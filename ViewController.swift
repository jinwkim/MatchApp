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

        // Get the card from card array
        let card = cardsArray[indexPath.row]

        // Configure the cell
        cell.configureCell(card: card)

        // Return the cell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell

        // Use optional in case cell is nil

        // Check the status of card to determine how to flip
        if cell?.card?.isFlipped == false {
            // Flip the card up
            cell?.flipUp(speed: 0.3)
        } else {
            // Flip the card down
            cell?.flipDown(speed: 0.3)
        }

    }

}

