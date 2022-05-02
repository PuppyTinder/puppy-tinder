//
//  RecentMatchCollectionViewCell.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit
import AlamofireImage

class RecentMatchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var puppyNameLabel: UILabel!
    
    override func layoutSubviews() {
        avatarImageView.image = avatarImageView.image?.af.imageAspectScaled(toFill: CGSize(width: 80, height: 80))
        avatarImageView.layer.cornerRadius = (avatarImageView.frame.height/2)
        avatarImageView.clipsToBounds = true
    }
}
