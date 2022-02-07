//
//  usersCell.swift
//  Kalmnychat
//
//  Created by Sherif samy on 3/1/21.
//  Copyright © 2021 Sherif samy. All rights reserved.
//

import UIKit

class usersCell: UITableViewCell {

    @IBOutlet weak var userimageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
