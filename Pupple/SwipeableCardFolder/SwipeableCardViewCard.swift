//
//  SwipeableCardViewCard.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import UIKit

class SwipeableCardViewCard : SwipeableView, NibView {
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            xibSetup()
        }
}
