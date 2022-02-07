//
//  myFriendsImageTVCell.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/15/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit

class myFriendsImageTVCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!{
        didSet{
            cellImageView.layer.cornerRadius = 10
        }
        
    }
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!{
        didSet{
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
