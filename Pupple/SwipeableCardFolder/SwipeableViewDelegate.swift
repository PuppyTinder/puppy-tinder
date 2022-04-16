//
//  SwipeableViewDelegate.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import Foundation

protocol SwipeableViewDelegate: class {
    
    func didTap(view: SwipeableView)
    
    func didBeginSwipe(onView view: SwipeableView)
    
    func didEndSwipe(onView view: SwipeableView)

}
