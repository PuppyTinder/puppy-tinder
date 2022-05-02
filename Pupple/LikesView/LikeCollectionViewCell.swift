//
//  LikeCollectionViewCell.swift
//  Pupple
//
//  Created by Mandy Yu on 4/19/22.
//

import UIKit
import AlamofireImage

class LikeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogBreedLabel: UILabel!
    
    override func layoutSubviews() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = CGColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 0.2)
        cellView.layer.masksToBounds = false
        
        ownerImageView.image = ownerImageView.image?.af.imageAspectScaled(toFill: CGSize(width: ownerImageView.frame.width/2, height: ownerImageView.frame.height/2))
        ownerImageView.layer.cornerRadius = ownerImageView.frame.height/2
        ownerImageView.clipsToBounds = true
        
        dogImageView.image = dogImageView.image?.af.imageAspectScaled(toFill: CGSize(width: dogImageView.frame.width, height: dogImageView.frame.height))
        dogImageView.layer.cornerRadius = 10
        dogImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dogImageView.clipsToBounds = true
    }
}
