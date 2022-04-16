//
//  SwipeableCardViewDelegate.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import Foundation

protocol SwipeableCardViewDelegate : class {
    
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int)
}
