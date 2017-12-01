//
//  ProfileTableViewCell.swift
//  Alpha
//
//  Created by Karla Padron on 12/1/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var post: UILabel!
    
    @IBOutlet weak var time: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
