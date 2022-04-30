//
//  MatchandMessageTableViewCell.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit

class MatchandMessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
/*
    @IBOutlet weak var unreadMessageCountLabel: UILabel!
    @IBOutlet weak var unreadMessageCountView: UIView!
*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
