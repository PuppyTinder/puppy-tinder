//
//  MatchandMessageTableViewCell.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit
import AlamofireImage

class MatchandMessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        dogImageView.image = dogImageView.image?.af.imageAspectScaled(toFill: CGSize(width: 60, height: 60))
        dogImageView.layer.cornerRadius = dogImageView.frame.height/2
        dogImageView.clipsToBounds = true
        
        userImageView.image = userImageView.image?.af.imageAspectScaled(toFill: CGSize(width: 30, height: 30))
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
    }

}
