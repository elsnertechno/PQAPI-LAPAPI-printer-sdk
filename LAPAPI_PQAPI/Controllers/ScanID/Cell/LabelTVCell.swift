//
//  LabelTVCell.swift
//  BaplsID
//
//  Created by Ahmad's MacMini on 27/01/23.
//  Copyright © 2023 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class LabelTVCell: UITableViewCell {

    @IBOutlet var btnEditAction: UIButton!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
