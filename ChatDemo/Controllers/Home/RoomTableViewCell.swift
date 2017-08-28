//
//  RoomTableViewCell.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
