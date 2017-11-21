//
//  MapFollowerTableViewCell.swift
//  Alpha
//
//  Created by Karla Padron on 11/8/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit

class MapFollowerTableViewCell: UITableViewCell {

    @IBOutlet var location: UILabel!
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
