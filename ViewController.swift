//
//  ViewController.swift
//  MatchApp
//
//  Created by Jin Kim on 6/15/20.
//  Copyright © 2020 Jin Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let model = CardModel()
    var cardsArray = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Generate cards to be used in the game
        cardsArray = model.getCards()
    }


}

