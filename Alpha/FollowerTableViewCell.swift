//
//  FollowerTableViewCell.swift
//  Alpha
//
//  Created by Karla Padron on 11/6/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {





    @IBOutlet weak var statusDot: UIImageView!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
