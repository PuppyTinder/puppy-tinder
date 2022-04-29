//
//  KolodaCardView.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/16/22.
//

import UIKit
import AlamofireImage

class KolodaCardView : UIView , NibView {
    
    @IBOutlet var containerUIView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    var dogObjectId: String? // Keeps a reference to a specific dog object
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        xibSetup()
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            xibSetup()
        }
}
