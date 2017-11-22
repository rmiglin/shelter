//
//  GeneralTableViewCell.swift
//  Alpha
//
//  Created by Karla Padron on 11/21/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var password: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var email: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
