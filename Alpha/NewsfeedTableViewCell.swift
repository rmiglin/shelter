//
//  NewsfeedTableViewCell.swift
//  Alpha
//
//  Created by Karla Padron on 12/1/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import UIKit


class NewsfeedTableViewCell: UITableViewCell {

    @IBOutlet weak var statusDot: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var post: UILabel!
    var postID: String!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var likeCounter: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
