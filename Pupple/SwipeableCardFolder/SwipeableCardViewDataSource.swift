//
//  SwipeableCardViewDataSource.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import UIKit

protocol SwipeableCardViewDataSource : class {
    
    // Returns: total number of cards to be displayed in the view
    func numberOfCards () -> Int
    
    // Parameter: index of the card to be displayed
    // Returns: card view to be displayed
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard
    
    // Returns the view when all cards have been swiped
    func viewForEmptyCards() -> UIView?
}
