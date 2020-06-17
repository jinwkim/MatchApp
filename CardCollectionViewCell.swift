//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Jin Kim on 6/15/20.
//  Copyright © 2020 Jin Kim. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!

    var card:Card?

    func configureCell(card:Card) {

        // Keep track of the card this cell represents
        self.card = card

        // Set front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)

        // Make visible if not matched, invisible if matched
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        // Reset the state of the cell by checking the flipped status of card, and then showing the front or the back imageview accordingly
        if card.isFlipped == true {

            // Show the front image view
            flipUp(speed:0)

        } else {

            // Show the back image view
            flipDown(speed:0,delay:0)
        }
    }

    func flipUp(speed:TimeInterval = 0.3) {

        // Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)

        // set status of card
        card?.isFlipped = true
    }

    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        // Add 0.5 second delay using DispatchQueue
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
            
            // Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        }

        // set status of card
        card?.isFlipped = false
    }
    
    func remove() {
        
        // Make image views invisible - set opacity to 0, make image disappear
        backImageView.alpha = 0
        
        // Use animation on frontImageView to visualize the disappearance
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)

    }
}
